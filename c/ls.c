/* `dir', `vdir' and `ls' directory listing programs for GNU.
   Copyright (C) 85, 88, 90, 91, 1995-2007 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* If ls_mode is LS_MULTI_COL,
   the multi-column format is the default regardless
   of the type of output device.
   This is for the `dir' program.

   If ls_mode is LS_LONG_FORMAT,
   the long format is the default regardless of the
   type of output device.
   This is for the `vdir' program.

   If ls_mode is LS_LS,
   the output format depends on whether the output
   device is a terminal.
   This is for the `ls' program.  */

/* Written by Richard Stallman and David MacKenzie.  */

/* Color support by Peter Anvin <Peter.Anvin@linux.org> and Dennis
   Flaherty <dennisf@denix.elk.miles.com> based on original patches by
   Greg Lee <lee@uhunix.uhcc.hawaii.edu>.  */

#include <config.h>
#include <sys/types.h>

#if HAVE_TERMIOS_H
# include <termios.h>
#endif
#if HAVE_STROPTS_H
# include <stropts.h>
#endif
#if HAVE_SYS_IOCTL_H
# include <sys/ioctl.h>
#endif

#ifdef WINSIZE_IN_PTEM
# include <sys/stream.h>
# include <sys/ptem.h>
#endif

#include <stdio.h>
#include <assert.h>
#include <setjmp.h>
#include <grp.h>
#include <pwd.h>
#include <getopt.h>
#include <signal.h>
#include <selinux/selinux.h>
#include <wchar.h>

/* Use SA_NOCLDSTOP as a proxy for whether the sigaction machinery is
   present.  */
#ifndef SA_NOCLDSTOP
# define SA_NOCLDSTOP 0
# define sigprocmask(How, Set, Oset) /* empty */
# define sigset_t int
# if ! HAVE_SIGINTERRUPT
#  define siginterrupt(sig, flag) /* empty */
# endif
#endif
#ifndef SA_RESTART
# define SA_RESTART 0
#endif

#include "system.h"
#include <fnmatch.h>

#include "acl.h"
#include "argmatch.h"
#include "dev-ino.h"
#include "dirfd.h"
#include "error.h"
#include "filenamecat.h"
#include "hard-locale.h"
#include "hash.h"
#include "human.h"
#include "filemode.h"
#include "idcache.h"
#include "inttostr.h"
#include "ls.h"
#include "lstat.h"
#include "mbswidth.h"
#include "mpsort.h"
#include "obstack.h"
#include "quote.h"
#include "quotearg.h"
#include "same.h"
#include "stat-time.h"
#include "strftime.h"
#include "strverscmp.h"
#include "xstrtol.h"
#include "areadlink.h"

#define PROGRAM_NAME (ls_mode == LS_LS ? "ls" \
		      : (ls_mode == LS_MULTI_COL \
			 ? "dir" : "vdir"))

#define AUTHORS "Richard Stallman", "David MacKenzie"

#define obstack_chunk_alloc malloc
#define obstack_chunk_free free

/* Return an int indicating the result of comparing two integers.
   Subtracting doesn't always work, due to overflow.  */
#define longdiff(a, b) ((a) < (b) ? -1 : (a) > (b))

#if ! HAVE_STRUCT_STAT_ST_AUTHOR
# define st_author st_uid
#endif

enum filetype
  {
    unknown,
    fifo,
    chardev,
    directory,
    blockdev,
    normal,
    symbolic_link,
    sock,
    whiteout,
    arg_directory
  };

/* Display letters and indicators for each filetype.
   Keep these in sync with enum filetype.  */
static char const filetype_letter[] = "?pcdb-lswd";

/* Ensure that filetype and filetype_letter have the same
   number of elements.  */
verify (sizeof filetype_letter - 1 == arg_directory + 1);

#define FILETYPE_INDICATORS				\
  {							\
    C_ORPHAN, C_FIFO, C_CHR, C_DIR, C_BLK, C_FILE,	\
    C_LINK, C_SOCK, C_FILE, C_DIR			\
  }


struct fileinfo
  {
    /* The file name.  */
    char *name;

    /* For symbolic link, name of the file linked to, otherwise zero.  */
    char *linkname;

    struct stat stat;

    enum filetype filetype;

    /* For symbolic link and long listing, st_mode of file linked to, otherwise
       zero.  */
    mode_t linkmode;

    /* SELinux security context.  */
    security_context_t scontext;

    bool stat_ok;

    /* For symbolic link and color printing, true if linked-to file
       exists, otherwise false.  */
    bool linkok;

    /* For long listings, true if the file has an access control list,
       or an SELinux security context.  */
    bool have_acl;
  };

#define LEN_STR_PAIR(s) sizeof (s) - 1, s

/* Null is a valid character in a color indicator (think about Epson
   printers, for example) so we have to use a length/buffer string
   type.  */

struct bin_str
  {
    size_t len;			/* Number of bytes */
    const char *string;		/* Pointer to the same */
  };

#if ! HAVE_TCGETPGRP
# define tcgetpgrp(Fd) 0
#endif

static size_t quote_name (FILE *out, const char *name,
			  struct quoting_options const *options,
			  size_t *width);
static char *make_link_name (char const *name, char const *linkname);
static int decode_switches (int argc, char **argv);
static bool file_ignored (char const *name);
static uintmax_t gobble_file (char const *name, enum filetype type,
			      ino_t inode, bool command_line_arg,
			      char const *dirname);
static void print_color_indicator (const char *name, mode_t mode, int linkok,
				   bool stat_ok, enum filetype type);
static void put_indicator (const struct bin_str *ind);
static void add_ignore_pattern (const char *pattern);
static void attach (char *dest, const char *dirname, const char *name);
static void clear_files (void);
static void extract_dirs_from_files (char const *dirname,
				     bool command_line_arg);
static void get_link_name (char const *filename, struct fileinfo *f,
			   bool command_line_arg);
static void indent (size_t from, size_t to);
static size_t calculate_columns (bool by_columns);
static void print_current_files (void);
static void print_dir (char const *name, char const *realname,
		       bool command_line_arg);
static void print_file_name_and_frills (const struct fileinfo *f);
static void print_horizontal (void);
static int format_user_width (uid_t u);
static int format_group_width (gid_t g);
static void print_long_format (const struct fileinfo *f);
static void print_many_per_line (void);
static void print_name_with_quoting (const char *p, mode_t mode,
				     int linkok, bool stat_ok,
				     enum filetype type,
				     struct obstack *stack);
static void prep_non_filename_text (void);
static void print_type_indicator (bool stat_ok, mode_t mode,
				  enum filetype type);
static void print_with_commas (void);
static void queue_directory (char const *name, char const *realname,
			     bool command_line_arg);
static void sort_files (void);
static void parse_ls_color (void);
void usage (int status);

/* The name this program was run with.  */
char *program_name;

/* Initial size of hash table.
   Most hierarchies are likely to be shallower than this.  */
#define INITIAL_TABLE_SIZE 30

/* The set of `active' directories, from the current command-line argument
   to the level in the hierarchy at which files are being listed.
   A directory is represented by its device and inode numbers (struct dev_ino).
   A directory is added to this set when ls begins listing it or its
   entries, and it is removed from the set just after ls has finished
   processing it.  This set is used solely to detect loops, e.g., with
   mkdir loop; cd loop; ln -s ../loop sub; ls -RL  */
static Hash_table *active_dir_set;

#define LOOP_DETECT (!!active_dir_set)

/* The table of files in the current directory:

   `cwd_file' points to a vector of `struct fileinfo', one per file.
   `cwd_n_alloc' is the number of elements space has been allocated for.
   `cwd_n_used' is the number actually in use.  */

/* Address of block containing the files that are described.  */
static struct fileinfo *cwd_file;

/* Length of block that `cwd_file' points to, measured in files.  */
static size_t cwd_n_alloc;

/* Index of first unused slot in `cwd_file'.  */
static size_t cwd_n_used;

/* Vector of pointers to files, in proper sorted order, and the number
   of entries allocated for it.  */
static void **sorted_file;
static size_t sorted_file_alloc;

/* When true, in a color listing, color each symlink name according to the
   type of file it points to.  Otherwise, color them according to the `ln'
   directive in LS_COLORS.  Dangling (orphan) symlinks are treated specially,
   regardless.  This is set when `ln=target' appears in LS_COLORS.  */

static bool color_symlink_as_referent;

/* mode of appropriate file for colorization */
#define FILE_OR_LINK_MODE(File) \
    ((color_symlink_as_referent & (File)->linkok) \
     ? (File)->linkmode : (File)->stat.st_mode)


/* Record of one pending directory waiting to be listed.  */

struct pending
  {
    char *name;
    /* If the directory is actually the file pointed to by a symbolic link we
       were told to list, `realname' will contain the name of the symbolic
       link, otherwise zero.  */
    char *realname;
    bool command_line_arg;
    struct pending *next;
  };

static struct pending *pending_dirs;

/* Current time in seconds and nanoseconds since 1970, updated as
   needed when deciding whether a file is recent.  */

static time_t current_time = TYPE_MINIMUM (time_t);
static int current_time_ns = -1;

static bool print_scontext;

/* Whether any of the files has an ACL.  This affects the width of the
   mode column.  */

static bool any_has_acl;

/* The number of columns to use for columns containing inode numbers,
   block sizes, link counts, owners, groups, authors, major device
   numbers, minor device numbers, and file sizes, respectively.  */

static int inode_number_width;
static int block_size_width;
static int nlink_width;
static int scontext_width;
static int owner_width;
static int group_width;
static int author_width;
static int major_device_number_width;
static int minor_device_number_width;
static int file_size_width;

/* Option flags */

/* long_format for lots of info, one per line.
   one_per_line for just names, one per line.
   many_per_line for just names, many per line, sorted vertically.
   horizontal for just names, many per line, sorted horizontally.
   with_commas for just names, many per line, separated by commas.

   -l (and other options that imply -l), -1, -C, -x and -m control
   this parameter.  */

enum format
  {
    long_format,		/* -l and other options that imply -l */
    one_per_line,		/* -1 */
    many_per_line,		/* -C */
    horizontal,			/* -x */
    with_commas			/* -m */
  };

static enum format format;

/* `full-iso' uses full ISO-style dates and times.  `long-iso' uses longer
   ISO-style time stamps, though shorter than `full-iso'.  `iso' uses shorter
   ISO-style time stamps.  `locale' uses locale-dependent time stamps.  */
enum time_style
  {
    full_iso_time_style,	/* --time-style=full-iso */
    long_iso_time_style,	/* --time-style=long-iso */
    iso_time_style,		/* --time-style=iso */
    locale_time_style		/* --time-style=locale */
  };

static char const *const time_style_args[] =
{
  "full-iso", "long-iso", "iso", "locale", NULL
};
static enum time_style const time_style_types[] =
{
  full_iso_time_style, long_iso_time_style, iso_time_style,
  locale_time_style
};
ARGMATCH_VERIFY (time_style_args, time_style_types);

/* Type of time to print or sort by.  Controlled by -c and -u.
   The values of each item of this enum are important since they are
   used as indices in the sort functions array (see sort_files()).  */

enum time_type
  {
    time_mtime,			/* default */
    time_ctime,			/* -c */
    time_atime,			/* -u */
    time_numtypes		/* the number of elements of this enum */
  };

static enum time_type time_type;

/* The file characteristic to sort by.  Controlled by -t, -S, -U, -X, -v.
   The values of each item of this enum are important since they are
   used as indices in the sort functions array (see sort_files()).  */

enum sort_type
  {
    sort_none = -1,		/* -U */
    sort_name,			/* default */
    sort_extension,		/* -X */
    sort_size,			/* -S */
    sort_version,		/* -v */
    sort_time,			/* -t */
    sort_numtypes		/* the number of elements of this enum */
  };

static enum sort_type sort_type;

/* Direction of sort.
   false means highest first if numeric,
   lowest first if alphabetic;
   these are the defaults.
   true means the opposite order in each case.  -r  */

static bool sort_reverse;

/* True means to display owner information.  -g turns this off.  */

static bool print_owner = true;

/* True means to display author information.  */

static bool print_author;

/* True means to display group information.  -G and -o turn this off.  */

static bool print_group = true;

/* True means print the user and group id's as numbers rather
   than as names.  -n  */

static bool numeric_ids;

/* True means mention the size in blocks of each file.  -s  */

static bool print_block_size;

/* Human-readable options for output.  */
static int human_output_opts;

/* The units to use when printing sizes other than file sizes.  */
static uintmax_t output_block_size;

/* Likewise, but for file sizes.  */
static uintmax_t file_output_block_size = 1;

/* Follow the output with a special string.  Using this format,
   Emacs' dired mode starts up twice as fast, and can handle all
   strange characters in file names.  */
static bool dired;

/* `none' means don't mention the type of files.
   `slash' means mention directories only, with a '/'.
   `file_type' means mention file types.
   `classify' means mention file types and mark executables.

   Controlled by -F, -p, and --indicator-style.  */

enum indicator_style
  {
    none,	/*     --indicator-style=none */
    slash,	/* -p, --indicator-style=slash */
    file_type,	/*     --indicator-style=file-type */
    classify	/* -F, --indicator-style=classify */
  };

static enum indicator_style indicator_style;

/* Names of indicator styles.  */
static char const *const indicator_style_args[] =
{
  "none", "slash", "file-type", "classify", NULL
};
static enum indicator_style const indicator_style_types[] =
{
  none, slash, file_type, classify
};
ARGMATCH_VERIFY (indicator_style_args, indicator_style_types);

/* True means use colors to mark types.  Also define the different
   colors as well as the stuff for the LS_COLORS environment variable.
   The LS_COLORS variable is now in a termcap-like format.  */

static bool print_with_color;

enum color_type
  {
    color_never,		/* 0: default or --color=never */
    color_always,		/* 1: --color=always */
    color_if_tty		/* 2: --color=tty */
  };

enum Dereference_symlink
  {
    DEREF_UNDEFINED = 1,
    DEREF_NEVER,
    DEREF_COMMAND_LINE_ARGUMENTS,	/* -H */
    DEREF_COMMAND_LINE_SYMLINK_TO_DIR,	/* the default, in certain cases */
    DEREF_ALWAYS			/* -L */
  };

enum indicator_no
  {
    C_LEFT, C_RIGHT, C_END, C_NORM, C_FILE, C_DIR, C_LINK, C_FIFO, C_SOCK,
    C_BLK, C_CHR, C_MISSING, C_ORPHAN, C_EXEC, C_DOOR, C_SETUID, C_SETGID,
    C_STICKY, C_OTHER_WRITABLE, C_STICKY_OTHER_WRITABLE
  };

static const char *const indicator_name[]=
  {
    "lc", "rc", "ec", "no", "fi", "di", "ln", "pi", "so",
    "bd", "cd", "mi", "or", "ex", "do", "su", "sg", "st",
    "ow", "tw", NULL
  };

struct color_ext_type
  {
    struct bin_str ext;		/* The extension we're looking for */
    struct bin_str seq;		/* The sequence to output when we do */
    struct color_ext_type *next;	/* Next in list */
  };

static struct bin_str color_indicator[] =
  {
    { LEN_STR_PAIR ("\033[") },		/* lc: Left of color sequence */
    { LEN_STR_PAIR ("m") },		/* rc: Right of color sequence */
    { 0, NULL },			/* ec: End color (replaces lc+no+rc) */
    { LEN_STR_PAIR ("0") },		/* no: Normal */
    { LEN_STR_PAIR ("0") },		/* fi: File: default */
    { LEN_STR_PAIR ("01;34") },		/* di: Directory: bright blue */
    { LEN_STR_PAIR ("01;36") },		/* ln: Symlink: bright cyan */
    { LEN_STR_PAIR ("33") },		/* pi: Pipe: yellow/brown */
    { LEN_STR_PAIR ("01;35") },		/* so: Socket: bright magenta */
    { LEN_STR_PAIR ("01;33") },		/* bd: Block device: bright yellow */
    { LEN_STR_PAIR ("01;33") },		/* cd: Char device: bright yellow */
    { 0, NULL },			/* mi: Missing file: undefined */
    { 0, NULL },			/* or: Orphaned symlink: undefined */
    { LEN_STR_PAIR ("01;32") },		/* ex: Executable: bright green */
    { LEN_STR_PAIR ("01;35") },		/* do: Door: bright magenta */
    { LEN_STR_PAIR ("37;41") },		/* su: setuid: white on red */
    { LEN_STR_PAIR ("30;43") },		/* sg: setgid: black on yellow */
    { LEN_STR_PAIR ("37;44") },		/* st: sticky: black on blue */
    { LEN_STR_PAIR ("34;42") },		/* ow: other-writable: blue on green */
    { LEN_STR_PAIR ("30;42") },		/* tw: ow w/ sticky: black on green */
  };

/* FIXME: comment  */
static struct color_ext_type *color_ext_list = NULL;

/* Buffer for color sequences */
static char *color_buf;

/* True means to check for orphaned symbolic link, for displaying
   colors.  */

static bool check_symlink_color;

/* True means mention the inode number of each file.  -i  */

static bool print_inode;

/* What to do with symbolic links.  Affected by -d, -F, -H, -l (and
   other options that imply -l), and -L.  */

static enum Dereference_symlink dereference;

/* True means when a directory is found, display info on its
   contents.  -R  */

static bool recursive;

/* True means when an argument is a directory name, display info
   on it itself.  -d  */

static bool immediate_dirs;

/* True means that directories are grouped before files. */

static bool directories_first;

/* Which files to ignore.  */

static enum
{
  /* Ignore files whose names start with `.', and files specified by
     --hide and --ignore.  */
  IGNORE_DEFAULT,

  /* Ignore `.', `..', and files specified by --ignore.  */
  IGNORE_DOT_AND_DOTDOT,

  /* Ignore only files specified by --ignore.  */
  IGNORE_MINIMAL
} ignore_mode;

/* A linked list of shell-style globbing patterns.  If a non-argument
   file name matches any of these patterns, it is ignored.
   Controlled by -I.  Multiple -I options accumulate.
   The -B option adds `*~' and `.*~' to this list.  */

struct ignore_pattern
  {
    const char *pattern;
    struct ignore_pattern *next;
  };

static struct ignore_pattern *ignore_patterns;

/* Similar to IGNORE_PATTERNS, except that -a or -A causes this
   variable itself to be ignored.  */
static struct ignore_pattern *hide_patterns;

/* True means output nongraphic chars in file names as `?'.
   (-q, --hide-control-chars)
   qmark_funny_chars and the quoting style (-Q, --quoting-style=WORD) are
   independent.  The algorithm is: first, obey the quoting style to get a
   string representing the file name;  then, if qmark_funny_chars is set,
   replace all nonprintable chars in that string with `?'.  It's necessary
   to replace nonprintable chars even in quoted strings, because we don't
   want to mess up the terminal if control chars get sent to it, and some
   quoting methods pass through control chars as-is.  */
static bool qmark_funny_chars;

/* Quoting options for file and dir name output.  */

static struct quoting_options *filename_quoting_options;
static struct quoting_options *dirname_quoting_options;

/* The number of chars per hardware tab stop.  Setting this to zero
   inhibits the use of TAB characters for separating columns.  -T */
static size_t tabsize;

/* True means print each directory name before listing it.  */

static bool print_dir_name;

/* The line length to use for breaking lines in many-per-line format.
   Can be set with -w.  */

static size_t line_length;

/* If true, the file listing format requires that stat be called on
   each file.  */

static bool format_needs_stat;

/* Similar to `format_needs_stat', but set if only the file type is
   needed.  */

static bool format_needs_type;

/* An arbitrary limit on the number of bytes in a printed time stamp.
   This is set to a relatively small value to avoid the need to worry
   about denial-of-service attacks on servers that run "ls" on behalf
   of remote clients.  1000 bytes should be enough for any practical
   time stamp format.  */

enum { TIME_STAMP_LEN_MAXIMUM = MAX (1000, INT_STRLEN_BOUND (time_t)) };

/* strftime formats for non-recent and recent files, respectively, in
   -l output.  */

static char const *long_time_format[2] =
  {
    /* strftime format for non-recent files (older than 6 months), in
       -l output.  This should contain the year, month and day (at
       least), in an order that is understood by people in your
       locale's territory.  Please try to keep the number of used
       screen columns small, because many people work in windows with
       only 80 columns.  But make this as wide as the other string
       below, for recent files.  */
    N_("%b %e  %Y"),
    /* strftime format for recent files (younger than 6 months), in -l
       output.  This should contain the month, day and time (at
       least), in an order that is understood by people in your
       locale's territory.  Please try to keep the number of used
       screen columns small, because many people work in windows with
       only 80 columns.  But make this as wide as the other string
       above, for non-recent files.  */
    N_("%b %e %H:%M")
  };

/* The set of signals that are caught.  */

static sigset_t caught_signals;

/* If nonzero, the value of the pending fatal signal.  */

static sig_atomic_t volatile interrupt_signal;

/* A count of the number of pending stop signals that have been received.  */

static sig_atomic_t volatile stop_signal_count;

/* Desired exit status.  */

static int exit_status;

/* Exit statuses.  */
enum
  {
    /* "ls" had a minor problem (e.g., it could not stat a directory
       entry).  */
    LS_MINOR_PROBLEM = 1,

    /* "ls" had more serious trouble.  */
    LS_FAILURE = 2
  };

/* For long options that have no equivalent short option, use a
   non-character as a pseudo short option, starting with CHAR_MAX + 1.  */
enum
{
  AUTHOR_OPTION = CHAR_MAX + 1,
  BLOCK_SIZE_OPTION,
  COLOR_OPTION,
  DEREFERENCE_COMMAND_LINE_SYMLINK_TO_DIR_OPTION,
  FILE_TYPE_INDICATOR_OPTION,
  FORMAT_OPTION,
  FULL_TIME_OPTION,
  GROUP_DIRECTORIES_FIRST_OPTION,
  HIDE_OPTION,
  INDICATOR_STYLE_OPTION,
  QUOTING_STYLE_OPTION,
  SHOW_CONTROL_CHARS_OPTION,
  SI_OPTION,
  SORT_OPTION,
  TIME_OPTION,
  TIME_STYLE_OPTION
};

static struct option const long_options[] =
{
  {"all", no_argument, NULL, 'a'},
  {"escape", no_argument, NULL, 'b'},
  {"directory", no_argument, NULL, 'd'},
  {"dired", no_argument, NULL, 'D'},
  {"full-time", no_argument, NULL, FULL_TIME_OPTION},
  {"group-directories-first", no_argument, NULL,
   GROUP_DIRECTORIES_FIRST_OPTION},
  {"human-readable", no_argument, NULL, 'h'},
  {"inode", no_argument, NULL, 'i'},
  {"numeric-uid-gid", no_argument, NULL, 'n'},
  {"no-group", no_argument, NULL, 'G'},
  {"hide-control-chars", no_argument, NULL, 'q'},
  {"reverse", no_argument, NULL, 'r'},
  {"size", no_argument, NULL, 's'},
  {"width", required_argument, NULL, 'w'},
  {"almost-all", no_argument, NULL, 'A'},
  {"ignore-backups", no_argument, NULL, 'B'},
  {"classify", no_argument, NULL, 'F'},
  {"file-type", no_argument, NULL, FILE_TYPE_INDICATOR_OPTION},
  {"si", no_argument, NULL, SI_OPTION},
  {"dereference-command-line", no_argument, NULL, 'H'},
  {"dereference-command-line-symlink-to-dir", no_argument, NULL,
   DEREFERENCE_COMMAND_LINE_SYMLINK_TO_DIR_OPTION},
  {"hide", required_argument, NULL, HIDE_OPTION},
  {"ignore", required_argument, NULL, 'I'},
  {"indicator-style", required_argument, NULL, INDICATOR_STYLE_OPTION},
  {"dereference", no_argument, NULL, 'L'},
  {"literal", no_argument, NULL, 'N'},
  {"quote-name", no_argument, NULL, 'Q'},
  {"quoting-style", required_argument, NULL, QUOTING_STYLE_OPTION},
  {"recursive", no_argument, NULL, 'R'},
  {"format", required_argument, NULL, FORMAT_OPTION},
  {"show-control-chars", no_argument, NULL, SHOW_CONTROL_CHARS_OPTION},
  {"sort", required_argument, NULL, SORT_OPTION},
  {"tabsize", required_argument, NULL, 'T'},
  {"time", required_argument, NULL, TIME_OPTION},
  {"time-style", required_argument, NULL, TIME_STYLE_OPTION},
  {"color", optional_argument, NULL, COLOR_OPTION},
  {"block-size", required_argument, NULL, BLOCK_SIZE_OPTION},
  {"context", no_argument, 0, 'Z'},
  {"author", no_argument, NULL, AUTHOR_OPTION},
  {GETOPT_HELP_OPTION_DECL},
  {GETOPT_VERSION_OPTION_DECL},
  {NULL, 0, NULL, 0}
};

static char const *const format_args[] =
{
  "verbose", "long", "commas", "horizontal", "across",
  "vertical", "single-column", NULL
};
static enum format const format_types[] =
{
  long_format, long_format, with_commas, horizontal, horizontal,
  many_per_line, one_per_line
};
ARGMATCH_VERIFY (format_args, format_types);

static char const *const sort_args[] =
{
  "none", "time", "size", "extension", "version", NULL
};
static enum sort_type const sort_types[] =
{
  sort_none, sort_time, sort_size, sort_extension, sort_version
};
ARGMATCH_VERIFY (sort_args, sort_types);

static char const *const time_args[] =
{
  "atime", "access", "use", "ctime", "status", NULL
};
static enum time_type const time_types[] =
{
  time_atime, time_atime, time_atime, time_ctime, time_ctime
};
ARGMATCH_VERIFY (time_args, time_types);

static char const *const color_args[] =
{
  /* force and none are for compatibility with another color-ls version */
  "always", "yes", "force",
  "never", "no", "none",
  "auto", "tty", "if-tty", NULL
};
static enum color_type const color_types[] =
{
  color_always, color_always, color_always,
  color_never, color_never, color_never,
  color_if_tty, color_if_tty, color_if_tty
};
ARGMATCH_VERIFY (color_args, color_types);

/* Information about filling a column.  */
struct column_info
{
  bool valid_len;
  size_t line_len;
  size_t *col_arr;
};

/* Array with information about column filledness.  */
static struct column_info *column_info;

/* Maximum number of columns ever possible for this display.  */
static size_t max_idx;

/* The minimum width of a column is 3: 1 character for the name and 2
   for the separating white space.  */
#define MIN_COLUMN_WIDTH	3


/* This zero-based index is used solely with the --dired option.
   When that option is in effect, this counter is incremented for each
   byte of output generated by this program so that the beginning
   and ending indices (in that output) of every file name can be recorded
   and later output themselves.  */
static size_t dired_pos;

#define DIRED_PUTCHAR(c) do {putchar ((c)); ++dired_pos;} while (0)

/* Write S to STREAM and increment DIRED_POS by S_LEN.  */
#define DIRED_FPUTS(s, stream, s_len) \
    do {fputs (s, stream); dired_pos += s_len;} while (0)

/* Like DIRED_FPUTS, but for use when S is a literal string.  */
#define DIRED_FPUTS_LITERAL(s, stream) \
    do {fputs (s, stream); dired_pos += sizeof (s) - 1;} while (0)

#define DIRED_INDENT()							\
    do									\
      {									\
	if (dired)							\
	  DIRED_FPUTS_LITERAL ("  ", stdout);				\
      }									\
    while (0)

/* With --dired, store pairs of beginning and ending indices of filenames.  */
static struct obstack dired_obstack;

/* With --dired, store pairs of beginning and ending indices of any
   directory names that appear as headers (just before `total' line)
   for lists of directory entries.  Such directory names are seen when
   listing hierarchies using -R and when a directory is listed with at
   least one other command line argument.  */
static struct obstack subdired_obstack;

/* Save the current index on the specified obstack, OBS.  */
#define PUSH_CURRENT_DIRED_POS(obs)					\
  do									\
    {									\
      if (dired)							\
	obstack_grow (obs, &dired_pos, sizeof (dired_pos));		\
    }									\
  while (0)

/* With -R, this stack is used to help detect directory cycles.
   The device/inode pairs on this stack mirror the pairs in the
   active_dir_set hash table.  */
static struct obstack dev_ino_obstack;

/* Push a pair onto the device/inode stack.  */
#define DEV_INO_PUSH(Dev, Ino)						\
  do									\
    {									\
      struct dev_ino *di;						\
      obstack_blank (&dev_ino_obstack, sizeof (struct dev_ino));	\
      di = -1 + (struct dev_ino *) obstack_next_free (&dev_ino_obstack); \
      di->st_dev = (Dev);						\
      di->st_ino = (Ino);						\
    }									\
  while (0)

/* Pop a dev/ino struct off the global dev_ino_obstack
   and return that struct.  */
static struct dev_ino
dev_ino_pop (void)
{
  assert (sizeof (struct dev_ino) <= obstack_object_size (&dev_ino_obstack));
  obstack_blank (&dev_ino_obstack, -(int) (sizeof (struct dev_ino)));
  return *(struct dev_ino *) obstack_next_free (&dev_ino_obstack);
}

#define ASSERT_MATCHING_DEV_INO(Name, Di)	\
  do						\
    {						\
      struct stat sb;				\
      assert (Name);				\
      assert (0 <= stat (Name, &sb));		\
      assert (sb.st_dev == Di.st_dev);		\
      assert (sb.st_ino == Di.st_ino);		\
    }						\
  while (0)


/* Write to standard output PREFIX, followed by the quoting style and
   a space-separated list of the integers stored in OS all on one line.  */

static void
dired_dump_obstack (const char *prefix, struct obstack *os)
{
  size_t n_pos;

  n_pos = obstack_object_size (os) / sizeof (dired_pos);
  if (n_pos > 0)
    {
      size_t i;
      size_t *pos;

      pos = (size_t *) obstack_finish (os);
      fputs (prefix, stdout);
      for (i = 0; i < n_pos; i++)
	printf (" %lu", (unsigned long int) pos[i]);
      putchar ('\n');
    }
}

static size_t
dev_ino_hash (void const *x, size_t table_size)
{
  struct dev_ino const *p = x;
  return (uintmax_t) p->st_ino % table_size;
}

static bool
dev_ino_compare (void const *x, void const *y)
{
  struct dev_ino const *a = x;
  struct dev_ino const *b = y;
  return SAME_INODE (*a, *b) ? true : false;
}

static void
dev_ino_free (void *x)
{
  free (x);
}

/* Add the device/inode pair (P->st_dev/P->st_ino) to the set of
   active directories.  Return true if there is already a matching
   entry in the table.  */

static bool
visit_dir (dev_t dev, ino_t ino)
{
  struct dev_ino *ent;
  struct dev_ino *ent_from_table;
  bool found_match;

  ent = xmalloc (sizeof *ent);
  ent->st_ino = ino;
  ent->st_dev = dev;

  /* Attempt to insert this entry into the table.  */
  ent_from_table = hash_insert (active_dir_set, ent);

  if (ent_from_table == NULL)
    {
      /* Insertion failed due to lack of memory.  */
      xalloc_die ();
    }

  found_match = (ent_from_table != ent);

  if (found_match)
    {
      /* ent was not inserted, so free it.  */
      free (ent);
    }

  return found_match;
}

static void
free_pending_ent (struct pending *p)
{
  free (p->name);
  free (p->realname);
  free (p);
}

static bool
is_colored (enum indicator_no type)
{
  size_t len = color_indicator[type].len;
  char const *s = color_indicator[type].string;
  return ! (len == 0
	    || (len == 1 && strncmp (s, "0", 1) == 0)
	    || (len == 2 && strncmp (s, "00", 2) == 0));
}

static void
restore_default_color (void)
{
  put_indicator (&color_indicator[C_LEFT]);
  put_indicator (&color_indicator[C_RIGHT]);
}

/* An ordinary signal was received; arrange for the program to exit.  */

static void
sighandler (int sig)
{
  if (! SA_NOCLDSTOP)
    signal (sig, SIG_IGN);
  if (! interrupt_signal)
    interrupt_signal = sig;
}

/* A SIGTSTP was received; arrange for the program to suspend itself.  */

static void
stophandler (int sig)
{
  if (! SA_NOCLDSTOP)
    signal (sig, stophandler);
  if (! interrupt_signal)
    stop_signal_count++;
}

/* Process any pending signals.  If signals are caught, this function
   should be called periodically.  Ideally there should never be an
   unbounded amount of time when signals are not being processed.
   Signal handling can restore the default colors, so callers must
   immediately change colors after invoking this function.  */

static void
process_signals (void)
{
  while (interrupt_signal | stop_signal_count)
    {
      int sig;
      int stops;
      sigset_t oldset;

      restore_default_color ();
      fflush (stdout);

      sigprocmask (SIG_BLOCK, &caught_signals, &oldset);

      /* Reload interrupt_signal and stop_signal_count, in case a new
	 signal was handled before sigprocmask took effect.  */
      sig = interrupt_signal;
      stops = stop_signal_count;

      /* SIGTSTP is special, since the application can receive that signal
	 more than once.  In this case, don't set the signal handler to the
	 default.  Instead, just raise the uncatchable SIGSTOP.  */
      if (stops)
	{
	  stop_signal_count = stops - 1;
	  sig = SIGSTOP;
	}
      else
	signal (sig, SIG_DFL);

      /* Exit or suspend the program.  */
      raise (sig);
      sigprocmask (SIG_SETMASK, &oldset, NULL);

      /* If execution reaches here, then the program has been
	 continued (after being suspended).  */
    }
}

int
main (int argc, char **argv)
{
  int i;
  struct pending *thispend;
  int n_files;

  /* The signals that are trapped, and the number of such signals.  */
  static int const sig[] =
    {
      /* This one is handled specially.  */
      SIGTSTP,

      /* The usual suspects.  */
      SIGALRM, SIGHUP, SIGINT, SIGPIPE, SIGQUIT, SIGTERM,
#ifdef SIGPOLL
      SIGPOLL,
#endif
#ifdef SIGPROF
      SIGPROF,
#endif
#ifdef SIGVTALRM
      SIGVTALRM,
#endif
#ifdef SIGXCPU
      SIGXCPU,
#endif
#ifdef SIGXFSZ
      SIGXFSZ,
#endif
    };
  enum { nsigs = sizeof sig / sizeof sig[0] };

#if ! SA_NOCLDSTOP
  bool caught_sig[nsigs];
#endif

  initialize_main (&argc, &argv);
  program_name = argv[0];
  setlocale (LC_ALL, "");
  bindtextdomain (PACKAGE, LOCALEDIR);
  textdomain (PACKAGE);

  initialize_exit_failure (LS_FAILURE);
  atexit (close_stdout);

#define N_ENTRIES(Array) (sizeof Array / sizeof *(Array))
  assert (N_ENTRIES (color_indicator) + 1 == N_ENTRIES (indicator_name));

  exit_status = EXIT_SUCCESS;
  print_dir_name = true;
  pending_dirs = NULL;

  i = decode_switches (argc, argv);

  if (print_with_color)
    parse_ls_color ();

  /* Test print_with_color again, because the call to parse_ls_color
     may have just reset it -- e.g., if LS_COLORS is invalid.  */
  if (print_with_color)
    {
      /* Avoid following symbolic links when possible.  */
      if (is_colored (C_ORPHAN)
	  || (is_colored (C_EXEC) && color_symlink_as_referent)
	  || (is_colored (C_MISSING) && format == long_format))
	check_symlink_color = true;

      /* If the standard output is a controlling terminal, watch out
         for signals, so that the colors can be restored to the
         default state if "ls" is suspended or interrupted.  */

      if (0 <= tcgetpgrp (STDOUT_FILENO))
	{
	  int j;
#if SA_NOCLDSTOP
	  struct sigaction act;

	  sigemptyset (&caught_signals);
	  for (j = 0; j < nsigs; j++)
	    {
	      sigaction (sig[j], NULL, &act);
	      if (act.sa_handler != SIG_IGN)
		sigaddset (&caught_signals, sig[j]);
	    }

	  act.sa_mask = caught_signals;
	  act.sa_flags = SA_RESTART;

	  for (j = 0; j < nsigs; j++)
	    if (sigismember (&caught_signals, sig[j]))
	      {
		act.sa_handler = sig[j] == SIGTSTP ? stophandler : sighandler;
		sigaction (sig[j], &act, NULL);
	      }
#else
	  for (j = 0; j < nsigs; j++)
	    {
	      caught_sig[j] = (signal (sig[j], SIG_IGN) != SIG_IGN);
	      if (caught_sig[j])
		{
		  signal (sig[j], sig[j] == SIGTSTP ? stophandler : sighandler);
		  siginterrupt (sig[j], 0);
		}
	    }
#endif
	}

      prep_non_filename_text ();
    }

  if (dereference == DEREF_UNDEFINED)
    dereference = ((immediate_dirs
		    || indicator_style == classify
		    || format == long_format)
		   ? DEREF_NEVER
		   : DEREF_COMMAND_LINE_SYMLINK_TO_DIR);

  /* When using -R, initialize a data structure we'll use to
     detect any directory cycles.  */
  if (recursive)
    {
      active_dir_set = hash_initialize (INITIAL_TABLE_SIZE, NULL,
					dev_ino_hash,
					dev_ino_compare,
					dev_ino_free);
      if (active_dir_set == NULL)
	xalloc_die ();

      obstack_init (&dev_ino_obstack);
    }

  format_needs_stat = sort_type == sort_time || sort_type == sort_size
    || format == long_format
    || print_scontext
    || print_block_size;
  format_needs_type = (! format_needs_stat
		       && (recursive
			   || print_with_color
			   || indicator_style != none
			   || directories_first));

  if (dired)
    {
      obstack_init (&dired_obstack);
      obstack_init (&subdired_obstack);
    }

  cwd_n_alloc = 100;
  cwd_file = xnmalloc (cwd_n_alloc, sizeof *cwd_file);
  cwd_n_used = 0;

  clear_files ();

  n_files = argc - i;

  if (n_files <= 0)
    {
      if (immediate_dirs)
	gobble_file (".", directory, NOT_AN_INODE_NUMBER, true, "");
      else
	queue_directory (".", NULL, true);
    }
  else
    do
      gobble_file (argv[i++], unknown, NOT_AN_INODE_NUMBER, true, "");
    while (i < argc);

  if (cwd_n_used)
    {
      sort_files ();
      if (!immediate_dirs)
	extract_dirs_from_files (NULL, true);
      /* `cwd_n_used' might be zero now.  */
    }

  /* In the following if/else blocks, it is sufficient to test `pending_dirs'
     (and not pending_dirs->name) because there may be no markers in the queue
     at this point.  A marker may be enqueued when extract_dirs_from_files is
     called with a non-empty string or via print_dir.  */
  if (cwd_n_used)
    {
      print_current_files ();
      if (pending_dirs)
	DIRED_PUTCHAR ('\n');
    }
  else if (n_files <= 1 && pending_dirs && pending_dirs->next == 0)
    print_dir_name = false;

  while (pending_dirs)
    {
      thispend = pending_dirs;
      pending_dirs = pending_dirs->next;

      if (LOOP_DETECT)
	{
	  if (thispend->name == NULL)
	    {
	      /* thispend->name == NULL means this is a marker entry
		 indicating we've finished processing the directory.
		 Use its dev/ino numbers to remove the corresponding
		 entry from the active_dir_set hash table.  */
	      struct dev_ino di = dev_ino_pop ();
	      struct dev_ino *found = hash_delete (active_dir_set, &di);
	      /* ASSERT_MATCHING_DEV_INO (thispend->realname, di); */
	      assert (found);
	      dev_ino_free (found);
	      free_pending_ent (thispend);
	      continue;
	    }
	}

      print_dir (thispend->name, thispend->realname,
		 thispend->command_line_arg);

      free_pending_ent (thispend);
      print_dir_name = true;
    }

  if (print_with_color)
    {
      int j;

      restore_default_color ();
      fflush (stdout);

      /* Restore the default signal handling.  */
#if SA_NOCLDSTOP
      for (j = 0; j < nsigs; j++)
	if (sigismember (&caught_signals, sig[j]))
	  signal (sig[j], SIG_DFL);
#else
      for (j = 0; j < nsigs; j++)
	if (caught_sig[j])
	  signal (sig[j], SIG_DFL);
#endif

      /* Act on any signals that arrived before the default was restored.
	 This can process signals out of order, but there doesn't seem to
	 be an easy way to do them in order, and the order isn't that
	 important anyway.  */
      for (j = stop_signal_count; j; j--)
	raise (SIGSTOP);
      j = interrupt_signal;
      if (j)
	raise (j);
    }

  if (dired)
    {
      /* No need to free these since we're about to exit.  */
      dired_dump_obstack ("//DIRED//", &dired_obstack);
      dired_dump_obstack ("//SUBDIRED//", &subdired_obstack);
      printf ("//DIRED-OPTIONS// --quoting-style=%s\n",
	      quoting_style_args[get_quoting_style (filename_quoting_options)]);
    }

  if (LOOP_DETECT)
    {
      assert (hash_get_n_entries (active_dir_set) == 0);
      hash_free (active_dir_set);
    }

  exit (exit_status);
}

/* Set all the option flags according to the switches specified.
   Return the index of the first non-option argument.  */

static int
decode_switches (int argc, char **argv)
{
  char *time_style_option = NULL;

  /* Record whether there is an option specifying sort type.  */
  bool sort_type_specified = false;

  qmark_funny_chars = false;

  /* initialize all switches to default settings */

  switch (ls_mode)
    {
    case LS_MULTI_COL:
      /* This is for the `dir' program.  */
      format = many_per_line;
      set_quoting_style (NULL, escape_quoting_style);
      break;

    case LS_LONG_FORMAT:
      /* This is for the `vdir' program.  */
      format = long_format;
      set_quoting_style (NULL, escape_quoting_style);
      break;

    case LS_LS:
      /* This is for the `ls' program.  */
      if (isatty (STDOUT_FILENO))
	{
	  format = many_per_line;
	  /* See description of qmark_funny_chars, above.  */
	  qmark_funny_chars = true;
	}
      else
	{
	  format = one_per_line;
	  qmark_funny_chars = false;
	}
      break;

    default:
      abort ();
    }

  time_type = time_mtime;
  sort_type = sort_name;
  sort_reverse = false;
  numeric_ids = false;
  print_block_size = false;
  indicator_style = none;
  print_inode = false;
  dereference = DEREF_UNDEFINED;
  recursive = false;
  immediate_dirs = false;
  ignore_mode = IGNORE_DEFAULT;
  ignore_patterns = NULL;
  hide_patterns = NULL;
  print_scontext = false;

  /* FIXME: put this in a function.  */
  {
    char const *q_style = getenv ("QUOTING_STYLE");
    if (q_style)
      {
	int i = ARGMATCH (q_style, quoting_style_args, quoting_style_vals);
	if (0 <= i)
	  set_quoting_style (NULL, quoting_style_vals[i]);
	else
	  error (0, 0,
	 _("ignoring invalid value of environment variable QUOTING_STYLE: %s"),
		 quotearg (q_style));
      }
  }

  {
    char const *ls_block_size = getenv ("LS_BLOCK_SIZE");
    human_options (ls_block_size,
		   &human_output_opts, &output_block_size);
    if (ls_block_size || getenv ("BLOCK_SIZE"))
      file_output_block_size = output_block_size;
  }

  line_length = 80;
  {
    char const *p = getenv ("COLUMNS");
    if (p && *p)
      {
	unsigned long int tmp_ulong;
	if (xstrtoul (p, NULL, 0, &tmp_ulong, NULL) == LONGINT_OK
	    && 0 < tmp_ulong && tmp_ulong <= SIZE_MAX)
	  {
	    line_length = tmp_ulong;
	  }
	else
	  {
	    error (0, 0,
	       _("ignoring invalid width in environment variable COLUMNS: %s"),
		   quotearg (p));
	  }
      }
  }

#ifdef TIOCGWINSZ
  {
    struct winsize ws;

    if (ioctl (STDOUT_FILENO, TIOCGWINSZ, &ws) != -1
	&& 0 < ws.ws_col && ws.ws_col == (size_t) ws.ws_col)
      line_length = ws.ws_col;
  }
#endif

  {
    char const *p = getenv ("TABSIZE");
    tabsize = 8;
    if (p)
      {
	unsigned long int tmp_ulong;
	if (xstrtoul (p, NULL, 0, &tmp_ulong, NULL) == LONGINT_OK
	    && tmp_ulong <= SIZE_MAX)
	  {
	    tabsize = tmp_ulong;
	  }
	else
	  {
	    error (0, 0,
	     _("ignoring invalid tab size in environment variable TABSIZE: %s"),
		   quotearg (p));
	  }
      }
  }

  for (;;)
    {
      int oi = -1;
      int c = getopt_long (argc, argv,
			   "abcdfghiklmnopqrstuvw:xABCDFGHI:LNQRST:UXZ1",
			   long_options, &oi);
      if (c == -1)
	break;

      switch (c)
	{
	case 'a':
	  ignore_mode = IGNORE_MINIMAL;
	  break;

	case 'b':
	  set_quoting_style (NULL, escape_quoting_style);
	  break;

	case 'c':
	  time_type = time_ctime;
	  break;

	case 'd':
	  immediate_dirs = true;
	  break;

	case 'f':
	  /* Same as enabling -a -U and disabling -l -s.  */
	  ignore_mode = IGNORE_MINIMAL;
	  sort_type = sort_none;
	  sort_type_specified = true;
	  /* disable -l */
	  if (format == long_format)
	    format = (isatty (STDOUT_FILENO) ? many_per_line : one_per_line);
	  print_block_size = false;	/* disable -s */
	  print_with_color = false;	/* disable --color */
	  break;

	case FILE_TYPE_INDICATOR_OPTION: /* --file-type */
	  indicator_style = file_type;
	  break;

	case 'g':
	  format = long_format;
	  print_owner = false;
	  break;

	case 'h':
	  human_output_opts = human_autoscale | human_SI | human_base_1024;
	  file_output_block_size = output_block_size = 1;
	  break;

	case 'i':
	  print_inode = true;
	  break;

	case 'k':
	  human_output_opts = 0;
	  file_output_block_size = output_block_size = 1024;
	  break;

	case 'l':
	  format = long_format;
	  break;

	case 'm':
	  format = with_commas;
	  break;

	case 'n':
	  numeric_ids = true;
	  format = long_format;
	  break;

	case 'o':  /* Just like -l, but don't display group info.  */
	  format = long_format;
	  print_group = false;
	  break;

	case 'p':
	  indicator_style = slash;
	  break;

	case 'q':
	  qmark_funny_chars = true;
	  break;

	case 'r':
	  sort_reverse = true;
	  break;

	case 's':
	  print_block_size = true;
	  break;

	case 't':
	  sort_type = sort_time;
	  sort_type_specified = true;
	  break;

	case 'u':
	  time_type = time_atime;
	  break;

	case 'v':
	  sort_type = sort_version;
	  sort_type_specified = true;
	  break;

	case 'w':
	  {
	    unsigned long int tmp_ulong;
	    if (xstrtoul (optarg, NULL, 0, &tmp_ulong, NULL) != LONGINT_OK
		|| ! (0 < tmp_ulong && tmp_ulong <= SIZE_MAX))
	      error (LS_FAILURE, 0, _("invalid line width: %s"),
		     quotearg (optarg));
	    line_length = tmp_ulong;
	    break;
	  }

	case 'x':
	  format = horizontal;
	  break;

	case 'A':
	  if (ignore_mode == IGNORE_DEFAULT)
	    ignore_mode = IGNORE_DOT_AND_DOTDOT;
	  break;

	case 'B':
	  add_ignore_pattern ("*~");
	  add_ignore_pattern (".*~");
	  break;

	case 'C':
	  format = many_per_line;
	  break;

	case 'D':
	  dired = true;
	  break;

	case 'F':
	  indicator_style = classify;
	  break;

	case 'G':		/* inhibit display of group info */
	  print_group = false;
	  break;

	case 'H':
	  dereference = DEREF_COMMAND_LINE_ARGUMENTS;
	  break;

	case DEREFERENCE_COMMAND_LINE_SYMLINK_TO_DIR_OPTION:
	  dereference = DEREF_COMMAND_LINE_SYMLINK_TO_DIR;
	  break;

	case 'I':
	  add_ignore_pattern (optarg);
	  break;

	case 'L':
	  dereference = DEREF_ALWAYS;
	  break;

	case 'N':
	  set_quoting_style (NULL, literal_quoting_style);
	  break;

	case 'Q':
	  set_quoting_style (NULL, c_quoting_style);
	  break;

	case 'R':
	  recursive = true;
	  break;

	case 'S':
	  sort_type = sort_size;
	  sort_type_specified = true;
	  break;

	case 'T':
	  {
	    unsigned long int tmp_ulong;
	    if (xstrtoul (optarg, NULL, 0, &tmp_ulong, NULL) != LONGINT_OK
		|| SIZE_MAX < tmp_ulong)
	      error (LS_FAILURE, 0, _("invalid tab size: %s"),
		     quotearg (optarg));
	    tabsize = tmp_ulong;
	    break;
	  }

	case 'U':
	  sort_type = sort_none;
	  sort_type_specified = true;
	  break;

	case 'X':
	  sort_type = sort_extension;
	  sort_type_specified = true;
	  break;

	case '1':
	  /* -1 has no effect after -l.  */
	  if (format != long_format)
	    format = one_per_line;
	  break;

        case AUTHOR_OPTION:
          print_author = true;
          break;

	case HIDE_OPTION:
	  {
	    struct ignore_pattern *hide = xmalloc (sizeof *hide);
	    hide->pattern = optarg;
	    hide->next = hide_patterns;
	    hide_patterns = hide;
	  }
	  break;

	case SORT_OPTION:
	  sort_type = XARGMATCH ("--sort", optarg, sort_args, sort_types);
	  sort_type_specified = true;
	  break;

	case GROUP_DIRECTORIES_FIRST_OPTION:
	  directories_first = true;
	  break;

	case TIME_OPTION:
	  time_type = XARGMATCH ("--time", optarg, time_args, time_types);
	  break;

	case FORMAT_OPTION:
	  format = XARGMATCH ("--format", optarg, format_args, format_types);
	  break;

	case FULL_TIME_OPTION:
	  format = long_format;
	  time_style_option = "full-iso";
	  break;

	case COLOR_OPTION:
	  {
	    int i;
	    if (optarg)
	      i = XARGMATCH ("--color", optarg, color_args, color_types);
	    else
	      /* Using --color with no argument is equivalent to using
		 --color=always.  */
	      i = color_always;

	    print_with_color = (i == color_always
				|| (i == color_if_tty
				    && isatty (STDOUT_FILENO)));

	    if (print_with_color)
	      {
		/* Don't use TAB characters in output.  Some terminal
		   emulators can't handle the combination of tabs and
		   color codes on the same line.  */
		tabsize = 0;
	      }
	    break;
	  }

	case INDICATOR_STYLE_OPTION:
	  indicator_style = XARGMATCH ("--indicator-style", optarg,
				       indicator_style_args,
				       indicator_style_types);
	  break;

	case QUOTING_STYLE_OPTION:
	  set_quoting_style (NULL,
			     XARGMATCH ("--quoting-style", optarg,
					quoting_style_args,
					quoting_style_vals));
	  break;

	case TIME_STYLE_OPTION:
	  time_style_option = optarg;
	  break;

	case SHOW_CONTROL_CHARS_OPTION:
	  qmark_funny_chars = false;
	  break;

	case BLOCK_SIZE_OPTION:
	  {
	    enum strtol_error e = human_options (optarg, &human_output_opts,
						 &output_block_size);
	    if (e != LONGINT_OK)
	      xstrtol_fatal (e, oi, 0, long_options, optarg);
	    file_output_block_size = output_block_size;
	  }
	  break;

	case SI_OPTION:
	  human_output_opts = human_autoscale | human_SI;
	  file_output_block_size = output_block_size = 1;
	  break;

	case 'Z':
	  print_scontext = true;
	  break;

	case_GETOPT_HELP_CHAR;

	case_GETOPT_VERSION_CHAR (PROGRAM_NAME, AUTHORS);

	default:
	  usage (LS_FAILURE);
	}
    }

  max_idx = MAX (1, line_length / MIN_COLUMN_WIDTH);

  filename_quoting_options = clone_quoting_options (NULL);
  if (get_quoting_style (filename_quoting_options) == escape_quoting_style)
    set_char_quoting (filename_quoting_options, ' ', 1);
  if (file_type <= indicator_style)
    {
      char const *p;
      for (p = "*=>@|" + indicator_style - file_type; *p; p++)
	set_char_quoting (filename_quoting_options, *p, 1);
    }

  dirname_quoting_options = clone_quoting_options (NULL);
  set_char_quoting (dirname_quoting_options, ':', 1);

  /* --dired is meaningful only with --format=long (-l).
     Otherwise, ignore it.  FIXME: warn about this?
     Alternatively, make --dired imply --format=long?  */
  if (dired && format != long_format)
    dired = false;

  /* If -c or -u is specified and not -l (or any other option that implies -l),
     and no sort-type was specified, then sort by the ctime (-c) or atime (-u).
     The behavior of ls when using either -c or -u but with neither -l nor -t
     appears to be unspecified by POSIX.  So, with GNU ls, `-u' alone means
     sort by atime (this is the one that's not specified by the POSIX spec),
     -lu means show atime and sort by name, -lut means show atime and sort
     by atime.  */

  if ((time_type == time_ctime || time_type == time_atime)
      && !sort_type_specified && format != long_format)
    {
      sort_type = sort_time;
    }

  if (format == long_format)
    {
      char *style = time_style_option;
      static char const posix_prefix[] = "posix-";

      if (! style)
	if (! (style = getenv ("TIME_STYLE")))
	  style = "locale";

      while (strncmp (style, posix_prefix, sizeof posix_prefix - 1) == 0)
	{
	  if (! hard_locale (LC_TIME))
	    return optind;
	  style += sizeof posix_prefix - 1;
	}

      if (*style == '+')
	{
	  char *p0 = style + 1;
	  char *p1 = strchr (p0, '\n');
	  if (! p1)
	    p1 = p0;
	  else
	    {
	      if (strchr (p1 + 1, '\n'))
		error (LS_FAILURE, 0, _("invalid time style format %s"),
		       quote (p0));
	      *p1++ = '\0';
	    }
	  long_time_format[0] = p0;
	  long_time_format[1] = p1;
	}
      else
	switch (XARGMATCH ("time style", style,
			   time_style_args,
			   time_style_types))
	  {
	  case full_iso_time_style:
	    long_time_format[0] = long_time_format[1] =
	      "%Y-%m-%d %H:%M:%S.%N %z";
	    break;

	  case long_iso_time_style:
	  case_long_iso_time_style:
	    long_time_format[0] = long_time_format[1] = "%Y-%m-%d %H:%M";
	    break;

	  case iso_time_style:
	    long_time_format[0] = "%Y-%m-%d ";
	    long_time_format[1] = "%m-%d %H:%M";
	    break;

	  case locale_time_style:
	    if (hard_locale (LC_TIME))
	      {
		/* Ensure that the locale has translations for both
		   formats.  If not, fall back on long-iso format.  */
		int i;
		for (i = 0; i < 2; i++)
		  {
		    char const *locale_format =
		      dcgettext (NULL, long_time_format[i], LC_TIME);
		    if (locale_format == long_time_format[i])
		      goto case_long_iso_time_style;
		    long_time_format[i] = locale_format;
		  }
	      }
	  }
    }

  return optind;
}

/* Parse a string as part of the LS_COLORS variable; this may involve
   decoding all kinds of escape characters.  If equals_end is set an
   unescaped equal sign ends the string, otherwise only a : or \0
   does.  Set *OUTPUT_COUNT to the number of bytes output.  Return
   true if successful.

   The resulting string is *not* null-terminated, but may contain
   embedded nulls.

   Note that both dest and src are char **; on return they point to
   the first free byte after the array and the character that ended
   the input string, respectively.  */

static bool
get_funky_string (char **dest, const char **src, bool equals_end,
		  size_t *output_count)
{
  char num;			/* For numerical codes */
  size_t count;			/* Something to count with */
  enum {
    ST_GND, ST_BACKSLASH, ST_OCTAL, ST_HEX, ST_CARET, ST_END, ST_ERROR
  } state;
  const char *p;
  char *q;

  p = *src;			/* We don't want to double-indirect */
  q = *dest;			/* the whole darn time.  */

  count = 0;			/* No characters counted in yet.  */
  num = 0;

  state = ST_GND;		/* Start in ground state.  */
  while (state < ST_END)
    {
      switch (state)
	{
	case ST_GND:		/* Ground state (no escapes) */
	  switch (*p)
	    {
	    case ':':
	    case '\0':
	      state = ST_END;	/* End of string */
	      break;
	    case '\\':
	      state = ST_BACKSLASH; /* Backslash scape sequence */
	      ++p;
	      break;
	    case '^':
	      state = ST_CARET; /* Caret escape */
	      ++p;
	      break;
	    case '=':
	      if (equals_end)
		{
		  state = ST_END; /* End */
		  break;
		}
	      /* else fall through */
	    default:
	      *(q++) = *(p++);
	      ++count;
	      break;
	    }
	  break;

	case ST_BACKSLASH:	/* Backslash escaped character */
	  switch (*p)
	    {
	    case '0':
	    case '1':
	    case '2':
	    case '3':
	    case '4':
	    case '5':
	    case '6':
	    case '7':
	      state = ST_OCTAL;	/* Octal sequence */
	      num = *p - '0';
	      break;
	    case 'x':
	    case 'X':
	      state = ST_HEX;	/* Hex sequence */
	      num = 0;
	      break;
	    case 'a':		/* Bell */
	      num = '\a';
	      break;
	    case 'b':		/* Backspace */
	      num = '\b';
	      break;
	    case 'e':		/* Escape */
	      num = 27;
	      break;
	    case 'f':		/* Form feed */
	      num = '\f';
	      break;
	    case 'n':		/* Newline */
	      num = '\n';
	      break;
	    case 'r':		/* Carriage return */
	      num = '\r';
	      break;
	    case 't':		/* Tab */
	      num = '\t';
	      break;
	    case 'v':		/* Vtab */
	      num = '\v';
	      break;
	    case '?':		/* Delete */
              num = 127;
	      break;
	    case '_':		/* Space */
	      num = ' ';
	      break;
	    case '\0':		/* End of string */
	      state = ST_ERROR;	/* Error! */
	      break;
	    default:		/* Escaped character like \ ^ : = */
	      num = *p;
	      break;
	    }
	  if (state == ST_BACKSLASH)
	    {
	      *(q++) = num;
	      ++count;
	      state = ST_GND;
	    }
	  ++p;
	  break;

	case ST_OCTAL:		/* Octal sequence */
	  if (*p < '0' || *p > '7')
	    {
	      *(q++) = num;
	      ++count;
	      state = ST_GND;
	    }
	  else
	    num = (num << 3) + (*(p++) - '0');
	  break;

	case ST_HEX:		/* Hex sequence */
	  switch (*p)
	    {
	    case '0':
	    case '1':
	    case '2':
	    case '3':
	    case '4':
	    case '5':
	    case '6':
	    case '7':
	    case '8':
	    case '9':
	      num = (num << 4) + (*(p++) - '0');
	      break;
	    case 'a':
	    case 'b':
	    case 'c':
	    case 'd':
	    case 'e':
	    case 'f':
	      num = (num << 4) + (*(p++) - 'a') + 10;
	      break;
	    case 'A':
	    case 'B':
	    case 'C':
	    case 'D':
	    case 'E':
	    case 'F':
	      num = (num << 4) + (*(p++) - 'A') + 10;
	      break;
	    default:
	      *(q++) = num;
	      ++count;
	      state = ST_GND;
	      break;
	    }
	  break;

	case ST_CARET:		/* Caret escape */
	  state = ST_GND;	/* Should be the next state... */
	  if (*p >= '@' && *p <= '~')
	    {
	      *(q++) = *(p++) & 037;
	      ++count;
	    }
	  else if (*p == '?')
	    {
	      *(q++) = 127;
	      ++count;
	    }
	  else
	    state = ST_ERROR;
	  break;

	default:
	  abort ();
	}
    }

  *dest = q;
  *src = p;
  *output_count = count;

  return state != ST_ERROR;
}

static void
parse_ls_color (void)
{
  const char *p;		/* Pointer to character being parsed */
  char *buf;			/* color_buf buffer pointer */
  int state;			/* State of parser */
  int ind_no;			/* Indicator number */
  char label[3];		/* Indicator label */
  struct color_ext_type *ext;	/* Extension we are working on */

  if ((p = getenv ("LS_COLORS")) == NULL || *p == '\0')
    return;

  ext = NULL;
  strcpy (label, "??");

  /* This is an overly conservative estimate, but any possible
     LS_COLORS string will *not* generate a color_buf longer than
     itself, so it is a safe way of allocating a buffer in
     advance.  */
  buf = color_buf = xstrdup (p);

  state = 1;
  while (state > 0)
    {
      switch (state)
	{
	case 1:		/* First label character */
	  switch (*p)
	    {
	    case ':':
	      ++p;
	      break;

	    case '*':
	      /* Allocate new extension block and add to head of
		 linked list (this way a later definition will
		 override an earlier one, which can be useful for
		 having terminal-specific defs override global).  */

	      ext = xmalloc (sizeof *ext);
	      ext->next = color_ext_list;
	      color_ext_list = ext;

	      ++p;
	      ext->ext.string = buf;

	      state = (get_funky_string (&buf, &p, true, &ext->ext.len)
		       ? 4 : -1);
	      break;

	    case '\0':
	      state = 0;	/* Done! */
	      break;

	    default:	/* Assume it is file type label */
	      label[0] = *(p++);
	      state = 2;
	      break;
	    }
	  break;

	case 2:		/* Second label character */
	  if (*p)
	    {
	      label[1] = *(p++);
	      state = 3;
	    }
	  else
	    state = -1;	/* Error */
	  break;

	case 3:		/* Equal sign after indicator label */
	  state = -1;	/* Assume failure...  */
	  if (*(p++) == '=')/* It *should* be...  */
	    {
	      for (ind_no = 0; indicator_name[ind_no] != NULL; ++ind_no)
		{
		  if (STREQ (label, indicator_name[ind_no]))
		    {
		      color_indicator[ind_no].string = buf;
		      state = (get_funky_string (&buf, &p, false,
						 &color_indicator[ind_no].len)
			       ? 1 : -1);
		      break;
		    }
		}
	      if (state == -1)
		error (0, 0, _("unrecognized prefix: %s"), quotearg (label));
	    }
	  break;

	case 4:		/* Equal sign after *.ext */
	  if (*(p++) == '=')
	    {
	      ext->seq.string = buf;
	      state = (get_funky_string (&buf, &p, false, &ext->seq.len)
		       ? 1 : -1);
	    }
	  else
	    state = -1;
	  break;
	}
    }

  if (state < 0)
    {
      struct color_ext_type *e;
      struct color_ext_type *e2;

      error (0, 0,
	     _("unparsable value for LS_COLORS environment variable"));
      free (color_buf);
      for (e = color_ext_list; e != NULL; /* empty */)
	{
	  e2 = e;
	  e = e->next;
	  free (e2);
	}
      print_with_color = false;
    }

  if (color_indicator[C_LINK].len == 6
      && !strncmp (color_indicator[C_LINK].string, "target", 6))
    color_symlink_as_referent = true;
}

/* Set the exit status to report a failure.  If SERIOUS, it is a
   serious failure; otherwise, it is merely a minor problem.  */

static void
set_exit_status (bool serious)
{
  if (serious)
    exit_status = LS_FAILURE;
  else if (exit_status == EXIT_SUCCESS)
    exit_status = LS_MINOR_PROBLEM;
}

/* Assuming a failure is serious if SERIOUS, use the printf-style
   MESSAGE to report the failure to access a file named FILE.  Assume
   errno is set appropriately for the failure.  */

static void
file_failure (bool serious, char const *message, char const *file)
{
  error (0, errno, message, quotearg_colon (file));
  set_exit_status (serious);
}

/* Request that the directory named NAME have its contents listed later.
   If REALNAME is nonzero, it will be used instead of NAME when the
   directory name is printed.  This allows symbolic links to directories
   to be treated as regular directories but still be listed under their
   real names.  NAME == NULL is used to insert a marker entry for the
   directory named in REALNAME.
   If NAME is non-NULL, we use its dev/ino information to save
   a call to stat -- when doing a recursive (-R) traversal.
   COMMAND_LINE_ARG means this directory was mentioned on the command line.  */

static void
queue_directory (char const *name, char const *realname, bool command_line_arg)
{
  struct pending *new = xmalloc (sizeof *new);
  new->realname = realname ? xstrdup (realname) : NULL;
  new->name = name ? xstrdup (name) : NULL;
  new->command_line_arg = command_line_arg;
  new->next = pending_dirs;
  pending_dirs = new;
}

/* Read directory NAME, and list the files in it.
   If REALNAME is nonzero, print its name instead of NAME;
   this is used for symbolic links to directories.
   COMMAND_LINE_ARG means this directory was mentioned on the command line.  */

static void
print_dir (char const *name, char const *realname, bool command_line_arg)
{
  DIR *dirp;
  struct dirent *next;
  uintmax_t total_blocks = 0;
  static bool first = true;

  errno = 0;
  dirp = opendir (name);
  if (!dirp)
    {
      file_failure (command_line_arg, _("cannot open directory %s"), name);
      return;
    }

  if (LOOP_DETECT)
    {
      struct stat dir_stat;
      int fd = dirfd (dirp);

      /* If dirfd failed, endure the overhead of using stat.  */
      if ((0 <= fd
	   ? fstat (fd, &dir_stat)
	   : stat (name, &dir_stat)) < 0)
	{
	  file_failure (command_line_arg,
			_("cannot determine device and inode of %s"), name);
	  closedir (dirp);
	  return;
	}

      /* If we've already visited this dev/inode pair, warn that
	 we've found a loop, and do not process this directory.  */
      if (visit_dir (dir_stat.st_dev, dir_stat.st_ino))
	{
	  error (0, 0, _("%s: not listing already-listed directory"),
		 quotearg_colon (name));
	  closedir (dirp);
	  return;
	}

      DEV_INO_PUSH (dir_stat.st_dev, dir_stat.st_ino);
    }

  /* Read the directory entries, and insert the subfiles into the `cwd_file'
     table.  */

  clear_files ();

  while (1)
    {
      /* Set errno to zero so we can distinguish between a readdir failure
	 and when readdir simply finds that there are no more entries.  */
      errno = 0;
      next = readdir (dirp);
      if (next)
	{
	  if (! file_ignored (next->d_name))
	    {
	      enum filetype type = unknown;

#if HAVE_STRUCT_DIRENT_D_TYPE
	      switch (next->d_type)
		{
		case DT_BLK:  type = blockdev;		break;
		case DT_CHR:  type = chardev;		break;
		case DT_DIR:  type = directory;		break;
		case DT_FIFO: type = fifo;		break;
		case DT_LNK:  type = symbolic_link;	break;
		case DT_REG:  type = normal;		break;
		case DT_SOCK: type = sock;		break;
# ifdef DT_WHT
		case DT_WHT:  type = whiteout;		break;
# endif
		}
#endif
	      total_blocks += gobble_file (next->d_name, type, D_INO (next),
					   false, name);
	    }
	}
      else if (errno != 0)
	{
	  file_failure (command_line_arg, _("reading directory %s"), name);
	  if (errno != EOVERFLOW)
	    break;
	}
      else
	break;
    }

  if (closedir (dirp) != 0)
    {
      file_failure (command_line_arg, _("closing directory %s"), name);
      /* Don't return; print whatever we got.  */
    }

  /* Sort the directory contents.  */
  sort_files ();

  /* If any member files are subdirectories, perhaps they should have their
     contents listed rather than being mentioned here as files.  */

  if (recursive)
    extract_dirs_from_files (name, command_line_arg);

  if (recursive | print_dir_name)
    {
      if (!first)
	DIRED_PUTCHAR ('\n');
      first = false;
      DIRED_INDENT ();
      PUSH_CURRENT_DIRED_POS (&subdired_obstack);
      dired_pos += quote_name (stdout, realname ? realname : name,
			       dirname_quoting_options, NULL);
      PUSH_CURRENT_DIRED_POS (&subdired_obstack);
      DIRED_FPUTS_LITERAL (":\n", stdout);
    }

  if (format == long_format || print_block_size)
    {
      const char *p;
      char buf[LONGEST_HUMAN_READABLE + 1];

      DIRED_INDENT ();
      p = _("total");
      DIRED_FPUTS (p, stdout, strlen (p));
      DIRED_PUTCHAR (' ');
      p = human_readable (total_blocks, buf, human_output_opts,
			  ST_NBLOCKSIZE, output_block_size);
      DIRED_FPUTS (p, stdout, strlen (p));
      DIRED_PUTCHAR ('\n');
    }

  if (cwd_n_used)
    print_current_files ();
}

/* Add `pattern' to the list of patterns for which files that match are
   not listed.  */

static void
add_ignore_pattern (const char *pattern)
{
  struct ignore_pattern *ignore;

  ignore = xmalloc (sizeof *ignore);
  ignore->pattern = pattern;
  /* Add it to the head of the linked list.  */
  ignore->next = ignore_patterns;
  ignore_patterns = ignore;
}

/* Return true if one of the PATTERNS matches FILE.  */

static bool
patterns_match (struct ignore_pattern const *patterns, char const *file)
{
  struct ignore_pattern const *p;
  for (p = patterns; p; p = p->next)
    if (fnmatch (p->pattern, file, FNM_PERIOD) == 0)
      return true;
  return false;
}

/* Return true if FILE should be ignored.  */

static bool
file_ignored (char const *name)
{
  return ((ignore_mode != IGNORE_MINIMAL
	   && name[0] == '.'
	   && (ignore_mode == IGNORE_DEFAULT || ! name[1 + (name[1] == '.')]))
	  || (ignore_mode == IGNORE_DEFAULT
	      && patterns_match (hide_patterns, name))
	  || patterns_match (ignore_patterns, name));
}

/* POSIX requires that a file size be printed without a sign, even
   when negative.  Assume the typical case where negative sizes are
   actually positive values that have wrapped around.  */

static uintmax_t
unsigned_file_size (off_t size)
{
  return size + (size < 0) * ((uintmax_t) OFF_T_MAX - OFF_T_MIN + 1);
}

/* Enter and remove entries in the table `cwd_file'.  */

/* Empty the table of files.  */

static void
clear_files (void)
{
  size_t i;

  for (i = 0; i < cwd_n_used; i++)
    {
      struct fileinfo *f = sorted_file[i];
      free (f->name);
      free (f->linkname);
      if (f->scontext)
	{
	  freecon (f->scontext);
	  f->scontext = NULL;
	}
    }

  cwd_n_used = 0;
  any_has_acl = false;
  inode_number_width = 0;
  block_size_width = 0;
  nlink_width = 0;
  owner_width = 0;
  group_width = 0;
  author_width = 0;
  scontext_width = 0;
  major_device_number_width = 0;
  minor_device_number_width = 0;
  file_size_width = 0;
}

/* Add a file to the current table of files.
   Verify that the file exists, and print an error message if it does not.
   Return the number of blocks that the file occupies.  */

static uintmax_t
gobble_file (char const *name, enum filetype type, ino_t inode,
	     bool command_line_arg, char const *dirname)
{
  uintmax_t blocks = 0;
  struct fileinfo *f;

  /* An inode value prior to gobble_file necessarily came from readdir,
     which is not used for command line arguments.  */
  assert (! command_line_arg || inode == NOT_AN_INODE_NUMBER);

  if (cwd_n_used == cwd_n_alloc)
    {
      cwd_file = xnrealloc (cwd_file, cwd_n_alloc, 2 * sizeof *cwd_file);
      cwd_n_alloc *= 2;
    }

  f = &cwd_file[cwd_n_used];
  memset (f, '\0', sizeof *f);
  f->stat.st_ino = inode;
  f->filetype = type;

  if (command_line_arg
      || format_needs_stat
      /* When coloring a directory (we may know the type from
	 direct.d_type), we have to stat it in order to indicate
	 sticky and/or other-writable attributes.  */
      || (type == directory && print_with_color)
      /* When dereferencing symlinks, the inode and type must come from
	 stat, but readdir provides the inode and type of lstat.  */
      || ((print_inode || format_needs_type)
	  && (type == symbolic_link || type == unknown)
	  && (dereference == DEREF_ALWAYS
	      || (command_line_arg && dereference != DEREF_NEVER)
	      || color_symlink_as_referent || check_symlink_color))
      /* Command line dereferences are already taken care of by the above
	 assertion that the inode number is not yet known.  */
      || (print_inode && inode == NOT_AN_INODE_NUMBER)
      || (format_needs_type
	  && (type == unknown || command_line_arg
	      /* --indicator-style=classify (aka -F)
		 requires that we stat each regular file
		 to see if it's executable.  */
	      || (type == normal && (indicator_style == classify
				     /* This is so that --color ends up
					highlighting files with the executable
					bit set even when options like -F are
					not specified.  */
				     || (print_with_color
					 && is_colored (C_EXEC))
				     )))))

    {
      /* FIXME-c99: move this decl "down", once ls.c stabilizes.  */
      bool file_has_security_context = false;
      /* Absolute name of this file.  */
      char *absolute_name;
      bool do_deref;
      int err;

      if (name[0] == '/' || dirname[0] == 0)
	absolute_name = (char *) name;
      else
	{
	  absolute_name = alloca (strlen (name) + strlen (dirname) + 2);
	  attach (absolute_name, dirname, name);
	}

      switch (dereference)
	{
	case DEREF_ALWAYS:
	  err = stat (absolute_name, &f->stat);
	  do_deref = true;
	  break;

	case DEREF_COMMAND_LINE_ARGUMENTS:
	case DEREF_COMMAND_LINE_SYMLINK_TO_DIR:
	  if (command_line_arg)
	    {
	      bool need_lstat;
	      err = stat (absolute_name, &f->stat);
	      do_deref = true;

	      if (dereference == DEREF_COMMAND_LINE_ARGUMENTS)
		break;

	      need_lstat = (err < 0
			    ? errno == ENOENT
			    : ! S_ISDIR (f->stat.st_mode));
	      if (!need_lstat)
		break;

	      /* stat failed because of ENOENT, maybe indicating a dangling
		 symlink.  Or stat succeeded, ABSOLUTE_NAME does not refer to a
		 directory, and --dereference-command-line-symlink-to-dir is
		 in effect.  Fall through so that we call lstat instead.  */
	    }

	default: /* DEREF_NEVER */
	  err = lstat (absolute_name, &f->stat);
	  do_deref = false;
	  break;
	}

      if (err == 0 && print_scontext)
	{
	  int attr_len = (do_deref
			  ?  getfilecon (absolute_name, &f->scontext)
			  : lgetfilecon (absolute_name, &f->scontext));
	  err = (attr_len < 0);
	  file_has_security_context =
	    (err == 0 && ! STREQ ("unlabeled", f->scontext));

	  /* When requesting security context information, don't make
	     ls fail just because the file (even a command line argument)
	     isn't on the right type of file system.  I.e., a getfilecon
	     failure isn't in the same class as a stat failure.  */
	  if (err && (errno == ENOTSUP || errno == ENODATA))
	    err = 0;
	}

      if (err != 0)
	{
	  /* Failure to stat a command line argument leads to
	     an exit status of 2.  For other files, stat failure
	     provokes an exit status of 1.  */
	  file_failure (command_line_arg,
			_("cannot access %s"), absolute_name);
	  if (command_line_arg)
	    return 0;

	  f->name = xstrdup (name);
	  cwd_n_used++;

	  return 0;
	}

      f->stat_ok = true;

      if (format == long_format)
	{
	  int n = file_has_acl (absolute_name, &f->stat);
	  f->have_acl = (0 < n || file_has_security_context);
	  any_has_acl |= f->have_acl;
	  if (n < 0)
	    error (0, errno, "%s", quotearg_colon (absolute_name));
	}

      if (S_ISLNK (f->stat.st_mode)
	  && (format == long_format || check_symlink_color))
	{
	  char *linkname;
	  struct stat linkstats;

	  get_link_name (absolute_name, f, command_line_arg);
	  linkname = make_link_name (absolute_name, f->linkname);

	  /* Avoid following symbolic links when possible, ie, when
	     they won't be traced and when no indicator is needed.  */
	  if (linkname
	      && (file_type <= indicator_style || check_symlink_color)
	      && stat (linkname, &linkstats) == 0)
	    {
	      f->linkok = true;

	      /* Symbolic links to directories that are mentioned on the
		 command line are automatically traced if not being
		 listed as files.  */
	      if (!command_line_arg || format == long_format
		  || !S_ISDIR (linkstats.st_mode))
		{
		  /* Get the linked-to file's mode for the filetype indicator
		     in long listings.  */
		  f->linkmode = linkstats.st_mode;
		}
	    }
	  free (linkname);
	}

      /* When not distinguishing types of symlinks, pretend we know that
	 it is stat'able, so that it will be colored as a regular symlink,
	 and not as an orphan.  */
      if (S_ISLNK (f->stat.st_mode) && !check_symlink_color)
	f->linkok = true;

      if (S_ISLNK (f->stat.st_mode))
	f->filetype = symbolic_link;
      else if (S_ISDIR (f->stat.st_mode))
	{
	  if (command_line_arg & !immediate_dirs)
	    f->filetype = arg_directory;
	  else
	    f->filetype = directory;
	}
      else
	f->filetype = normal;

      blocks = ST_NBLOCKS (f->stat);
      if (format == long_format || print_block_size)
	{
	  char buf[LONGEST_HUMAN_READABLE + 1];
	  int len = mbswidth (human_readable (blocks, buf, human_output_opts,
					      ST_NBLOCKSIZE, output_block_size),
			      0);
	  if (block_size_width < len)
	    block_size_width = len;
	}

      if (format == long_format)
	{
	  if (print_owner)
	    {
	      int len = format_user_width (f->stat.st_uid);
	      if (owner_width < len)
		owner_width = len;
	    }

	  if (print_group)
	    {
	      int len = format_group_width (f->stat.st_gid);
	      if (group_width < len)
		group_width = len;
	    }

	  if (print_author)
	    {
	      int len = format_user_width (f->stat.st_author);
	      if (author_width < len)
		author_width = len;
	    }
	}

      if (print_scontext)
	{
	  int len = f->scontext ? strlen (f->scontext) : 0;
	  if (scontext_width < len)
	    scontext_width = len;
	}

      if (format == long_format)
	{
	  char b[INT_BUFSIZE_BOUND (uintmax_t)];
	  int b_len = strlen (umaxtostr (f->stat.st_nlink, b));
	  if (nlink_width < b_len)
	    nlink_width = b_len;

	  if (S_ISCHR (f->stat.st_mode) || S_ISBLK (f->stat.st_mode))
	    {
	      char buf[INT_BUFSIZE_BOUND (uintmax_t)];
	      int len = strlen (umaxtostr (major (f->stat.st_rdev), buf));
	      if (major_device_number_width < len)
		major_device_number_width = len;
	      len = strlen (umaxtostr (minor (f->stat.st_rdev), buf));
	      if (minor_device_number_width < len)
		minor_device_number_width = len;
	      len = major_device_number_width + 2 + minor_device_number_width;
	      if (file_size_width < len)
		file_size_width = len;
	    }
	  else
	    {
	      char buf[LONGEST_HUMAN_READABLE + 1];
	      uintmax_t size = unsigned_file_size (f->stat.st_size);
	      int len = mbswidth (human_readable (size, buf, human_output_opts,
						  1, file_output_block_size),
				  0);
	      if (file_size_width < len)
		file_size_width = len;
	    }
	}
    }

  if (print_inode)
    {
      char buf[INT_BUFSIZE_BOUND (uintmax_t)];
      int len = strlen (umaxtostr (f->stat.st_ino, buf));
      if (inode_number_width < len)
	inode_number_width = len;
    }

  f->name = xstrdup (name);
  cwd_n_used++;

  return blocks;
}

/* Return true if F refers to a directory.  */
static bool
is_directory (const struct fileinfo *f)
{
  return f->filetype == directory || f->filetype == arg_directory;
}

/* Put the name of the file that FILENAME is a symbolic link to
   into the LINKNAME field of `f'.  COMMAND_LINE_ARG indicates whether
   FILENAME is a command-line argument.  */

static void
get_link_name (char const *filename, struct fileinfo *f, bool command_line_arg)
{
  f->linkname = areadlink_with_size (filename, f->stat.st_size);
  if (f->linkname == NULL)
    file_failure (command_line_arg, _("cannot read symbolic link %s"),
		  filename);
}

/* If `linkname' is a relative name and `name' contains one or more
   leading directories, return `linkname' with those directories
   prepended; otherwise, return a copy of `linkname'.
   If `linkname' is zero, return zero.  */

static char *
make_link_name (char const *name, char const *linkname)
{
  char *linkbuf;
  size_t bufsiz;

  if (!linkname)
    return NULL;

  if (*linkname == '/')
    return xstrdup (linkname);

  /* The link is to a relative name.  Prepend any leading directory
     in `name' to the link name.  */
  linkbuf = strrchr (name, '/');
  if (linkbuf == 0)
    return xstrdup (linkname);

  bufsiz = linkbuf - name + 1;
  linkbuf = xmalloc (bufsiz + strlen (linkname) + 1);
  strncpy (linkbuf, name, bufsiz);
  strcpy (linkbuf + bufsiz, linkname);
  return linkbuf;
}

/* Return true if the last component of NAME is `.' or `..'
   This is so we don't try to recurse on `././././. ...' */

static bool
basename_is_dot_or_dotdot (const char *name)
{
  char const *base = last_component (name);
  return dot_or_dotdot (base);
}

/* Remove any entries from CWD_FILE that are for directories,
   and queue them to be listed as directories instead.
   DIRNAME is the prefix to prepend to each dirname
   to make it correct relative to ls's working dir;
   if it is null, no prefix is needed and "." and ".." should not be ignored.
   If COMMAND_LINE_ARG is true, this directory was mentioned at the top level,
   This is desirable when processing directories recursively.  */

static void
extract_dirs_from_files (char const *dirname, bool command_line_arg)
{
  size_t i;
  size_t j;
  bool ignore_dot_and_dot_dot = (dirname != NULL);

  if (dirname && LOOP_DETECT)
    {
      /* Insert a marker entry first.  When we dequeue this marker entry,
	 we'll know that DIRNAME has been processed and may be removed
	 from the set of active directories.  */
      queue_directory (NULL, dirname, false);
    }

  /* Queue the directories last one first, because queueing reverses the
     order.  */
  for (i = cwd_n_used; i-- != 0; )
    {
      struct fileinfo *f = sorted_file[i];

      if (is_directory (f)
	  && (! ignore_dot_and_dot_dot
	      || ! basename_is_dot_or_dotdot (f->name)))
	{
	  if (!dirname || f->name[0] == '/')
	    queue_directory (f->name, f->linkname, command_line_arg);
	  else
	    {
	      char *name = file_name_concat (dirname, f->name, NULL);
	      queue_directory (name, f->linkname, command_line_arg);
	      free (name);
	    }
	  if (f->filetype == arg_directory)
	    free (f->name);
	}
    }

  /* Now delete the directories from the table, compacting all the remaining
     entries.  */

  for (i = 0, j = 0; i < cwd_n_used; i++)
    {
      struct fileinfo *f = sorted_file[i];
      sorted_file[j] = f;
      j += (f->filetype != arg_directory);
    }
  cwd_n_used = j;
}

/* Use strcoll to compare strings in this locale.  If an error occurs,
   report an error and longjmp to failed_strcoll.  */

static jmp_buf failed_strcoll;

static int
xstrcoll (char const *a, char const *b)
{
  int diff;
  errno = 0;
  diff = strcoll (a, b);
  if (errno)
    {
      error (0, errno, _("cannot compare file names %s and %s"),
	     quote_n (0, a), quote_n (1, b));
      set_exit_status (false);
      longjmp (failed_strcoll, 1);
    }
  return diff;
}

/* Comparison routines for sorting the files.  */

typedef void const *V;
typedef int (*qsortFunc)(V a, V b);

/* Used below in DEFINE_SORT_FUNCTIONS for _df_ sort function variants.
   The do { ... } while(0) makes it possible to use the macro more like
   a statement, without violating C89 rules: */
#define DIRFIRST_CHECK(a, b)						\
  do									\
    {									\
      bool a_is_dir = is_directory ((struct fileinfo const *) a);	\
      bool b_is_dir = is_directory ((struct fileinfo const *) b);	\
      if (a_is_dir && !b_is_dir)					\
	return -1;         /* a goes before b */			\
      if (!a_is_dir && b_is_dir)					\
	return 1;          /* b goes before a */			\
    }									\
  while (0)

/* Define the 8 different sort function variants required for each sortkey.
   KEY_NAME is a token describing the sort key, e.g., ctime, atime, size.
   KEY_CMP_FUNC is a function to compare records based on that key, e.g.,
   ctime_cmp, atime_cmp, size_cmp.  Append KEY_NAME to the string,
   '[rev_][x]str{cmp|coll}[_df]_', to create each function name.  */
#define DEFINE_SORT_FUNCTIONS(key_name, key_cmp_func)			\
  /* direct, non-dirfirst versions */					\
  static int xstrcoll_##key_name (V a, V b)				\
  { return key_cmp_func (a, b, xstrcoll); }				\
  static int strcmp_##key_name (V a, V b)				\
  { return key_cmp_func (a, b, strcmp); }				\
									\
  /* reverse, non-dirfirst versions */					\
  static int rev_xstrcoll_##key_name (V a, V b)				\
  { return key_cmp_func (b, a, xstrcoll); }				\
  static int rev_strcmp_##key_name (V a, V b)				\
  { return key_cmp_func (b, a, strcmp); }				\
									\
  /* direct, dirfirst versions */					\
  static int xstrcoll_df_##key_name (V a, V b)				\
  { DIRFIRST_CHECK (a, b); return key_cmp_func (a, b, xstrcoll); }	\
  static int strcmp_df_##key_name (V a, V b)				\
  { DIRFIRST_CHECK (a, b); return key_cmp_func (a, b, strcmp); }	\
									\
  /* reverse, dirfirst versions */					\
  static int rev_xstrcoll_df_##key_name (V a, V b)			\
  { DIRFIRST_CHECK (a, b); return key_cmp_func (b, a, xstrcoll); }	\
  static int rev_strcmp_df_##key_name (V a, V b)			\
  { DIRFIRST_CHECK (a, b); return key_cmp_func (b, a, strcmp); }

static inline int
cmp_ctime (struct fileinfo const *a, struct fileinfo const *b,
	   int (*cmp) (char const *, char const *))
{
  int diff = timespec_cmp (get_stat_ctime (&b->stat),
			   get_stat_ctime (&a->stat));
  return diff ? diff : cmp (a->name, b->name);
}

static inline int
cmp_mtime (struct fileinfo const *a, struct fileinfo const *b,
	   int (*cmp) (char const *, char const *))
{
  int diff = timespec_cmp (get_stat_mtime (&b->stat),
			   get_stat_mtime (&a->stat));
  return diff ? diff : cmp (a->name, b->name);
}

static inline int
cmp_atime (struct fileinfo const *a, struct fileinfo const *b,
	   int (*cmp) (char const *, char const *))
{
  int diff = timespec_cmp (get_stat_atime (&b->stat),
			   get_stat_atime (&a->stat));
  return diff ? diff : cmp (a->name, b->name);
}

static inline int
cmp_size (struct fileinfo const *a, struct fileinfo const *b,
	  int (*cmp) (char const *, char const *))
{
  int diff = longdiff (b->stat.st_size, a->stat.st_size);
  return diff ? diff : cmp (a->name, b->name);
}

static inline int
cmp_name (struct fileinfo const *a, struct fileinfo const *b,
	  int (*cmp) (char const *, char const *))
{
  return cmp (a->name, b->name);
}

/* Compare file extensions.  Files with no extension are `smallest'.
   If extensions are the same, compare by filenames instead.  */

static inline int
cmp_extension (struct fileinfo const *a, struct fileinfo const *b,
	       int (*cmp) (char const *, char const *))
{
  char const *base1 = strrchr (a->name, '.');
  char const *base2 = strrchr (b->name, '.');
  int diff = cmp (base1 ? base1 : "", base2 ? base2 : "");
  return diff ? diff : cmp (a->name, b->name);
}

DEFINE_SORT_FUNCTIONS (ctime, cmp_ctime)
DEFINE_SORT_FUNCTIONS (mtime, cmp_mtime)
DEFINE_SORT_FUNCTIONS (atime, cmp_atime)
DEFINE_SORT_FUNCTIONS (size, cmp_size)
DEFINE_SORT_FUNCTIONS (name, cmp_name)
DEFINE_SORT_FUNCTIONS (extension, cmp_extension)

/* Compare file versions.
   Unlike all other compare functions above, cmp_version depends only
   on strverscmp, which does not fail (even for locale reasons), and does not
   need a secondary sort key.
   All the other sort options, in fact, need xstrcoll and strcmp variants,
   because they all use a string comparison (either as the primary or secondary
   sort key), and xstrcoll has the ability to do a longjmp if strcoll fails for
   locale reasons.  Last, strverscmp is ALWAYS available in coreutils,
   thanks to the gnulib library. */
static inline int
cmp_version (struct fileinfo const *a, struct fileinfo const *b)
{
  return strverscmp (a->name, b->name);
}

static int xstrcoll_version (V a, V b)
{ return cmp_version (a, b); }
static int rev_xstrcoll_version (V a, V b)
{ return cmp_version (b, a); }
static int xstrcoll_df_version (V a, V b)
{ DIRFIRST_CHECK (a, b); return cmp_version (a, b); }
static int rev_xstrcoll_df_version (V a, V b)
{ DIRFIRST_CHECK (a, b); return cmp_version (b, a); }


/* We have 2^3 different variants for each sortkey function
   (for 3 independent sort modes).
   The function pointers stored in this array must be dereferenced as:

    sort_variants[sort_key][use_strcmp][reverse][dirs_first]

   Note that the order in which sortkeys are listed in the function pointer
   array below is defined by the order of the elements in the time_type and
   sort_type enums!  */

#define LIST_SORTFUNCTION_VARIANTS(key_name)                        \
  {                                                                 \
    {                                                               \
      { xstrcoll_##key_name, xstrcoll_df_##key_name },              \
      { rev_xstrcoll_##key_name, rev_xstrcoll_df_##key_name },      \
    },                                                              \
    {                                                               \
      { strcmp_##key_name, strcmp_df_##key_name },                  \
      { rev_strcmp_##key_name, rev_strcmp_df_##key_name },          \
    }                                                               \
  }

static qsortFunc sort_functions[][2][2][2] =
  {
    LIST_SORTFUNCTION_VARIANTS (name),
    LIST_SORTFUNCTION_VARIANTS (extension),
    LIST_SORTFUNCTION_VARIANTS (size),

    {
      {
        { xstrcoll_version, xstrcoll_df_version },
        { rev_xstrcoll_version, rev_xstrcoll_df_version },
      },

      /* We use NULL for the strcmp variants of version comparison
         since as explained in cmp_version definition, version comparison
         does not rely on xstrcoll, so it will never longjmp, and never
         need to try the strcmp fallback. */
      {
        { NULL, NULL },
        { NULL, NULL },
      }
    },

    /* last are time sort functions */
    LIST_SORTFUNCTION_VARIANTS (mtime),
    LIST_SORTFUNCTION_VARIANTS (ctime),
    LIST_SORTFUNCTION_VARIANTS (atime)
  };

/* The number of sortkeys is calculated as
     the number of elements in the sort_type enum (i.e. sort_numtypes) +
     the number of elements in the time_type enum (i.e. time_numtypes) - 1
   This is because when sort_type==sort_time, we have up to
   time_numtypes possible sortkeys.

   This line verifies at compile-time that the array of sort functions has been
   initialized for all possible sortkeys. */
verify (ARRAY_CARDINALITY (sort_functions)
	== sort_numtypes + time_numtypes - 1 );

/* Set up SORTED_FILE to point to the in-use entries in CWD_FILE, in order.  */

static void
initialize_ordering_vector (void)
{
  size_t i;
  for (i = 0; i < cwd_n_used; i++)
    sorted_file[i] = &cwd_file[i];
}

/* Sort the files now in the table.  */

static void
sort_files (void)
{
  bool use_strcmp;

  if (sorted_file_alloc < cwd_n_used + cwd_n_used / 2)
    {
      free (sorted_file);
      sorted_file = xnmalloc (cwd_n_used, 3 * sizeof *sorted_file);
      sorted_file_alloc = 3 * cwd_n_used;
    }

  initialize_ordering_vector ();

  if (sort_type == sort_none)
    return;

  /* Try strcoll.  If it fails, fall back on strcmp.  We can't safely
     ignore strcoll failures, as a failing strcoll might be a
     comparison function that is not a total order, and if we ignored
     the failure this might cause qsort to dump core.  */

  if (! setjmp (failed_strcoll))
    use_strcmp = false;      /* strcoll() succeeded */
  else
    {
      use_strcmp = true;
      assert (sort_type != sort_version);
      initialize_ordering_vector ();
    }

  /* When sort_type == sort_time, use time_type as subindex.  */
  mpsort ((void const **) sorted_file, cwd_n_used,
	  sort_functions[sort_type + (sort_type == sort_time ? time_type : 0)]
			[use_strcmp][sort_reverse]
			[directories_first]);
}

/* List all the files now in the table.  */

static void
print_current_files (void)
{
  size_t i;

  switch (format)
    {
    case one_per_line:
      for (i = 0; i < cwd_n_used; i++)
	{
	  print_file_name_and_frills (sorted_file[i]);
	  putchar ('\n');
	}
      break;

    case many_per_line:
      print_many_per_line ();
      break;

    case horizontal:
      print_horizontal ();
      break;

    case with_commas:
      print_with_commas ();
      break;

    case long_format:
      for (i = 0; i < cwd_n_used; i++)
	{
	  print_long_format (sorted_file[i]);
	  DIRED_PUTCHAR ('\n');
	}
      break;
    }
}

/* Return the expected number of columns in a long-format time stamp,
   or zero if it cannot be calculated.  */

static int
long_time_expected_width (void)
{
  static int width = -1;

  if (width < 0)
    {
      time_t epoch = 0;
      struct tm const *tm = localtime (&epoch);
      char buf[TIME_STAMP_LEN_MAXIMUM + 1];

      /* In case you're wondering if localtime can fail with an input time_t
	 value of 0, let's just say it's very unlikely, but not inconceivable.
	 The TZ environment variable would have to specify a time zone that
	 is 2**31-1900 years or more ahead of UTC.  This could happen only on
	 a 64-bit system that blindly accepts e.g., TZ=UTC+20000000000000.
	 However, this is not possible with Solaris 10 or glibc-2.3.5, since
	 their implementations limit the offset to 167:59 and 24:00, resp.  */
      if (tm)
	{
	  size_t len =
	    nstrftime (buf, sizeof buf, long_time_format[0], tm, 0, 0);
	  if (len != 0)
	    width = mbsnwidth (buf, len, 0);
	}

      if (width < 0)
	width = 0;
    }

  return width;
}

/* Get the current time.  */

static void
get_current_time (void)
{
#if HAVE_CLOCK_GETTIME && defined CLOCK_REALTIME
  {
    struct timespec timespec;
    if (clock_gettime (CLOCK_REALTIME, &timespec) == 0)
      {
	current_time = timespec.tv_sec;
	current_time_ns = timespec.tv_nsec;
	return;
      }
  }
#endif

  /* The clock does not have nanosecond resolution, so get the maximum
     possible value for the current time that is consistent with the
     reported clock.  That way, files are not considered to be in the
     future merely because their time stamps have higher resolution
     than the clock resolution.  */

#if HAVE_GETTIMEOFDAY
  {
    struct timeval timeval;
    gettimeofday (&timeval, NULL);
    current_time = timeval.tv_sec;
    current_time_ns = timeval.tv_usec * 1000 + 999;
  }
#else
  current_time = time (NULL);
  current_time_ns = 999999999;
#endif
}

/* Print the user or group name NAME, with numeric id ID, using a
   print width of WIDTH columns.  */

static void
format_user_or_group (char const *name, unsigned long int id, int width)
{
  size_t len;

  if (name)
    {
      int width_gap = width - mbswidth (name, 0);
      int pad = MAX (0, width_gap);
      fputs (name, stdout);
      len = strlen (name) + pad;

      do
	putchar (' ');
      while (pad--);
    }
  else
    {
      printf ("%*lu ", width, id);
      len = width;
    }

  dired_pos += len + 1;
}

/* Print the name or id of the user with id U, using a print width of
   WIDTH.  */

static void
format_user (uid_t u, int width, bool stat_ok)
{
  format_user_or_group (! stat_ok ? "?" :
			(numeric_ids ? NULL : getuser (u)), u, width);
}

/* Likewise, for groups.  */

static void
format_group (gid_t g, int width, bool stat_ok)
{
  format_user_or_group (! stat_ok ? "?" :
			(numeric_ids ? NULL : getgroup (g)), g, width);
}

/* Return the number of columns that format_user_or_group will print.  */

static int
format_user_or_group_width (char const *name, unsigned long int id)
{
  if (name)
    {
      int len = mbswidth (name, 0);
      return MAX (0, len);
    }
  else
    {
      char buf[INT_BUFSIZE_BOUND (unsigned long int)];
      sprintf (buf, "%lu", id);
      return strlen (buf);
    }
}

/* Return the number of columns that format_user will print.  */

static int
format_user_width (uid_t u)
{
  return format_user_or_group_width (numeric_ids ? NULL : getuser (u), u);
}

/* Likewise, for groups.  */

static int
format_group_width (gid_t g)
{
  return format_user_or_group_width (numeric_ids ? NULL : getgroup (g), g);
}


/* Print information about F in long format.  */

static void
print_long_format (const struct fileinfo *f)
{
  char modebuf[12];
  char buf
    [LONGEST_HUMAN_READABLE + 1		/* inode */
     + LONGEST_HUMAN_READABLE + 1	/* size in blocks */
     + sizeof (modebuf) - 1 + 1		/* mode string */
     + INT_BUFSIZE_BOUND (uintmax_t)	/* st_nlink */
     + LONGEST_HUMAN_READABLE + 2	/* major device number */
     + LONGEST_HUMAN_READABLE + 1	/* minor device number */
     + TIME_STAMP_LEN_MAXIMUM + 1	/* max length of time/date */
     ];
  size_t s;
  char *p;
  time_t when;
  int when_ns;
  struct timespec when_timespec;
  struct tm *when_local;

  /* Compute the mode string, except remove the trailing space if no
     file in this directory has an ACL or SELinux security context.  */
  if (f->stat_ok)
    filemodestring (&f->stat, modebuf);
  else
    {
      modebuf[0] = filetype_letter[f->filetype];
      memset (modebuf + 1, '?', 10);
      modebuf[11] = '\0';
    }
  if (! any_has_acl)
    modebuf[10] = '\0';
  else if (f->have_acl)
    modebuf[10] = '+';

  switch (time_type)
    {
    case time_ctime:
      when_timespec = get_stat_ctime (&f->stat);
      break;
    case time_mtime:
      when_timespec = get_stat_mtime (&f->stat);
      break;
    case time_atime:
      when_timespec = get_stat_atime (&f->stat);
      break;
    default:
      abort ();
    }

  when = when_timespec.tv_sec;
  when_ns = when_timespec.tv_nsec;

  p = buf;

  if (print_inode)
    {
      char hbuf[INT_BUFSIZE_BOUND (uintmax_t)];
      sprintf (p, "%*s ", inode_number_width,
	       (f->stat.st_ino == NOT_AN_INODE_NUMBER
		? "?"
		: umaxtostr (f->stat.st_ino, hbuf)));
      /* Increment by strlen (p) here, rather than by inode_number_width + 1.
	 The latter is wrong when inode_number_width is zero.  */
      p += strlen (p);
    }

  if (print_block_size)
    {
      char hbuf[LONGEST_HUMAN_READABLE + 1];
      char const *blocks =
	(! f->stat_ok
	 ? "?"
	 : human_readable (ST_NBLOCKS (f->stat), hbuf, human_output_opts,
			   ST_NBLOCKSIZE, output_block_size));
      int pad;
      for (pad = block_size_width - mbswidth (blocks, 0); 0 < pad; pad--)
	*p++ = ' ';
      while ((*p++ = *blocks++))
	continue;
      p[-1] = ' ';
    }

  /* The last byte of the mode string is the POSIX
     "optional alternate access method flag".  */
  {
    char hbuf[INT_BUFSIZE_BOUND (uintmax_t)];
    sprintf (p, "%s %*s ", modebuf, nlink_width,
	     ! f->stat_ok ? "?" : umaxtostr (f->stat.st_nlink, hbuf));
  }
  /* Increment by strlen (p) here, rather than by, e.g.,
     sizeof modebuf - 2 + any_has_acl + 1 + nlink_width + 1.
     The latter is wrong when nlink_width is zero.  */
  p += strlen (p);

  DIRED_INDENT ();

  if (print_owner | print_group | print_author | print_scontext)
    {
      DIRED_FPUTS (buf, stdout, p - buf);

      if (print_owner)
	format_user (f->stat.st_uid, owner_width, f->stat_ok);

      if (print_group)
	format_group (f->stat.st_gid, group_width, f->stat_ok);

      if (print_author)
	format_user (f->stat.st_author, author_width, f->stat_ok);

      if (print_scontext)
	format_user_or_group ((f->scontext ? f->scontext : "?"),
			      0, scontext_width);

      p = buf;
    }

  if (f->stat_ok
      && (S_ISCHR (f->stat.st_mode) || S_ISBLK (f->stat.st_mode)))
    {
      char majorbuf[INT_BUFSIZE_BOUND (uintmax_t)];
      char minorbuf[INT_BUFSIZE_BOUND (uintmax_t)];
      int blanks_width = (file_size_width
			  - (major_device_number_width + 2
			     + minor_device_number_width));
      sprintf (p, "%*s, %*s ",
	       major_device_number_width + MAX (0, blanks_width),
	       umaxtostr (major (f->stat.st_rdev), majorbuf),
	       minor_device_number_width,
	       umaxtostr (minor (f->stat.st_rdev), minorbuf));
      p += file_size_width + 1;
    }
  else
    {
      char hbuf[LONGEST_HUMAN_READABLE + 1];
      char const *size =
	(! f->stat_ok
	 ? "?"
	 : human_readable (unsigned_file_size (f->stat.st_size),
			   hbuf, human_output_opts, 1, file_output_block_size));
      int pad;
      for (pad = file_size_width - mbswidth (size, 0); 0 < pad; pad--)
	*p++ = ' ';
      while ((*p++ = *size++))
	continue;
      p[-1] = ' ';
    }

  when_local = localtime (&when_timespec.tv_sec);
  s = 0;
  *p = '\1';

  if (f->stat_ok && when_local)
    {
      time_t six_months_ago;
      bool recent;
      char const *fmt;

      /* If the file appears to be in the future, update the current
	 time, in case the file happens to have been modified since
	 the last time we checked the clock.  */
      if (current_time < when
	  || (current_time == when && current_time_ns < when_ns))
	{
	  /* Note that get_current_time calls gettimeofday which, on some non-
	     compliant systems, clobbers the buffer used for localtime's result.
	     But it's ok here, because we use a gettimeofday wrapper that
	     saves and restores the buffer around the gettimeofday call.  */
	  get_current_time ();
	}

      /* Consider a time to be recent if it is within the past six
	 months.  A Gregorian year has 365.2425 * 24 * 60 * 60 ==
	 31556952 seconds on the average.  Write this value as an
	 integer constant to avoid floating point hassles.  */
      six_months_ago = current_time - 31556952 / 2;
      recent = (six_months_ago <= when
		&& (when < current_time
		    || (when == current_time && when_ns <= current_time_ns)));
      fmt = long_time_format[recent];

      s = nstrftime (p, TIME_STAMP_LEN_MAXIMUM + 1, fmt,
		     when_local, 0, when_ns);
    }

  if (s || !*p)
    {
      p += s;
      *p++ = ' ';

      /* NUL-terminate the string -- fputs (via DIRED_FPUTS) requires it.  */
      *p = '\0';
    }
  else
    {
      /* The time cannot be converted using the desired format, so
	 print it as a huge integer number of seconds.  */
      char hbuf[INT_BUFSIZE_BOUND (intmax_t)];
      sprintf (p, "%*s ", long_time_expected_width (),
	       (! f->stat_ok
		? "?"
		: (TYPE_SIGNED (time_t)
		   ? imaxtostr (when, hbuf)
		   : umaxtostr (when, hbuf))));
      p += strlen (p);
    }

  DIRED_FPUTS (buf, stdout, p - buf);
  print_name_with_quoting (f->name, FILE_OR_LINK_MODE (f), f->linkok,
			   f->stat_ok, f->filetype, &dired_obstack);

  if (f->filetype == symbolic_link)
    {
      if (f->linkname)
	{
	  DIRED_FPUTS_LITERAL (" -> ", stdout);
	  print_name_with_quoting (f->linkname, f->linkmode, f->linkok - 1,
				   f->stat_ok, f->filetype, NULL);
	  if (indicator_style != none)
	    print_type_indicator (true, f->linkmode, unknown);
	}
    }
  else if (indicator_style != none)
    print_type_indicator (f->stat_ok, f->stat.st_mode, f->filetype);
}

/* Output to OUT a quoted representation of the file name NAME,
   using OPTIONS to control quoting.  Produce no output if OUT is NULL.
   Store the number of screen columns occupied by NAME's quoted
   representation into WIDTH, if non-NULL.  Return the number of bytes
   produced.  */

static size_t
quote_name (FILE *out, const char *name, struct quoting_options const *options,
	    size_t *width)
{
  char smallbuf[BUFSIZ];
  size_t len = quotearg_buffer (smallbuf, sizeof smallbuf, name, -1, options);
  char *buf;
  size_t displayed_width IF_LINT (= 0);

  if (len < sizeof smallbuf)
    buf = smallbuf;
  else
    {
      buf = alloca (len + 1);
      quotearg_buffer (buf, len + 1, name, -1, options);
    }

  if (qmark_funny_chars)
    {
#if HAVE_MBRTOWC
      if (MB_CUR_MAX > 1)
	{
	  char const *p = buf;
	  char const *plimit = buf + len;
	  char *q = buf;
	  displayed_width = 0;

	  while (p < plimit)
	    switch (*p)
	      {
		case ' ': case '!': case '"': case '#': case '%':
		case '&': case '\'': case '(': case ')': case '*':
		case '+': case ',': case '-': case '.': case '/':
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9':
		case ':': case ';': case '<': case '=': case '>':
		case '?':
		case 'A': case 'B': case 'C': case 'D': case 'E':
		case 'F': case 'G': case 'H': case 'I': case 'J':
		case 'K': case 'L': case 'M': case 'N': case 'O':
		case 'P': case 'Q': case 'R': case 'S': case 'T':
		case 'U': case 'V': case 'W': case 'X': case 'Y':
		case 'Z':
		case '[': case '\\': case ']': case '^': case '_':
		case 'a': case 'b': case 'c': case 'd': case 'e':
		case 'f': case 'g': case 'h': case 'i': case 'j':
		case 'k': case 'l': case 'm': case 'n': case 'o':
		case 'p': case 'q': case 'r': case 's': case 't':
		case 'u': case 'v': case 'w': case 'x': case 'y':
		case 'z': case '{': case '|': case '}': case '~':
		  /* These characters are printable ASCII characters.  */
		  *q++ = *p++;
		  displayed_width += 1;
		  break;
		default:
		  /* If we have a multibyte sequence, copy it until we
		     reach its end, replacing each non-printable multibyte
		     character with a single question mark.  */
		  {
		    mbstate_t mbstate = { 0, };
		    do
		      {
			wchar_t wc;
			size_t bytes;
			int w;

			bytes = mbrtowc (&wc, p, plimit - p, &mbstate);

			if (bytes == (size_t) -1)
			  {
			    /* An invalid multibyte sequence was
			       encountered.  Skip one input byte, and
			       put a question mark.  */
			    p++;
			    *q++ = '?';
			    displayed_width += 1;
			    break;
			  }

			if (bytes == (size_t) -2)
			  {
			    /* An incomplete multibyte character
			       at the end.  Replace it entirely with
			       a question mark.  */
			    p = plimit;
			    *q++ = '?';
			    displayed_width += 1;
			    break;
			  }

			if (bytes == 0)
			  /* A null wide character was encountered.  */
			  bytes = 1;

			w = wcwidth (wc);
			if (w >= 0)
			  {
			    /* A printable multibyte character.
			       Keep it.  */
			    for (; bytes > 0; --bytes)
			      *q++ = *p++;
			    displayed_width += w;
			  }
			else
			  {
			    /* An unprintable multibyte character.
			       Replace it entirely with a question
			       mark.  */
			    p += bytes;
			    *q++ = '?';
			    displayed_width += 1;
			  }
		      }
		    while (! mbsinit (&mbstate));
		  }
		  break;
	      }

	  /* The buffer may have shrunk.  */
	  len = q - buf;
	}
      else
#endif
	{
	  char *p = buf;
	  char const *plimit = buf + len;

	  while (p < plimit)
	    {
	      if (! isprint (to_uchar (*p)))
		*p = '?';
	      p++;
	    }
	  displayed_width = len;
	}
    }
  else if (width != NULL)
    {
#if HAVE_MBRTOWC
      if (MB_CUR_MAX > 1)
	displayed_width = mbsnwidth (buf, len, 0);
      else
#endif
	{
	  char const *p = buf;
	  char const *plimit = buf + len;

	  displayed_width = 0;
	  while (p < plimit)
	    {
	      if (isprint (to_uchar (*p)))
		displayed_width++;
	      p++;
	    }
	}
    }

  if (out != NULL)
    fwrite (buf, 1, len, out);
  if (width != NULL)
    *width = displayed_width;
  return len;
}

static void
print_name_with_quoting (const char *p, mode_t mode, int linkok,
			 bool stat_ok, enum filetype type,
			 struct obstack *stack)
{
  if (print_with_color)
    print_color_indicator (p, mode, linkok, stat_ok, type);

  if (stack)
    PUSH_CURRENT_DIRED_POS (stack);

  dired_pos += quote_name (stdout, p, filename_quoting_options, NULL);

  if (stack)
    PUSH_CURRENT_DIRED_POS (stack);

  if (print_with_color)
    {
      process_signals ();
      prep_non_filename_text ();
    }
}

static void
prep_non_filename_text (void)
{
  if (color_indicator[C_END].string != NULL)
    put_indicator (&color_indicator[C_END]);
  else
    {
      put_indicator (&color_indicator[C_LEFT]);
      put_indicator (&color_indicator[C_NORM]);
      put_indicator (&color_indicator[C_RIGHT]);
    }
}

/* Print the file name of `f' with appropriate quoting.
   Also print file size, inode number, and filetype indicator character,
   as requested by switches.  */

static void
print_file_name_and_frills (const struct fileinfo *f)
{
  char buf[MAX (LONGEST_HUMAN_READABLE + 1, INT_BUFSIZE_BOUND (uintmax_t))];

  if (print_inode)
    printf ("%*s ", format == with_commas ? 0 : inode_number_width,
	    umaxtostr (f->stat.st_ino, buf));

  if (print_block_size)
    printf ("%*s ", format == with_commas ? 0 : block_size_width,
	    human_readable (ST_NBLOCKS (f->stat), buf, human_output_opts,
			    ST_NBLOCKSIZE, output_block_size));

  if (print_scontext)
    printf ("%*s ", format == with_commas ? 0 : scontext_width,
	    (f->scontext ? f->scontext : "?"));

  print_name_with_quoting (f->name, FILE_OR_LINK_MODE (f), f->linkok,
			   f->stat_ok, f->filetype, NULL);

  if (indicator_style != none)
    print_type_indicator (f->stat_ok, f->stat.st_mode, f->filetype);
}

/* Given these arguments describing a file, return the single-byte
   type indicator, or 0.  */
static char
get_type_indicator (bool stat_ok, mode_t mode, enum filetype type)
{
  char c;

  if (stat_ok ? S_ISREG (mode) : type == normal)
    {
      if (stat_ok && indicator_style == classify && (mode & S_IXUGO))
	c = '*';
      else
	c = 0;
    }
  else
    {
      if (stat_ok ? S_ISDIR (mode) : type == directory || type == arg_directory)
	c = '/';
      else if (indicator_style == slash)
	c = 0;
      else if (stat_ok ? S_ISLNK (mode) : type == symbolic_link)
	c = '@';
      else if (stat_ok ? S_ISFIFO (mode) : type == fifo)
	c = '|';
      else if (stat_ok ? S_ISSOCK (mode) : type == sock)
	c = '=';
      else if (stat_ok && S_ISDOOR (mode))
	c = '>';
      else
	c = 0;
    }
  return c;
}

static void
print_type_indicator (bool stat_ok, mode_t mode, enum filetype type)
{
  char c = get_type_indicator (stat_ok, mode, type);
  if (c)
    DIRED_PUTCHAR (c);
}

static void
print_color_indicator (const char *name, mode_t mode, int linkok,
		       bool stat_ok, enum filetype filetype)
{
  int type;
  struct color_ext_type *ext;	/* Color extension */
  size_t len;			/* Length of name */

  /* Is this a nonexistent file?  If so, linkok == -1.  */

  if (linkok == -1 && color_indicator[C_MISSING].string != NULL)
    type = C_MISSING;
  else if (! stat_ok)
    {
      static enum indicator_no filetype_indicator[] = FILETYPE_INDICATORS;
      type = filetype_indicator[filetype];
    }
  else
    {
      if (S_ISREG (mode))
	{
	  type = C_FILE;
	  if ((mode & S_ISUID) != 0)
	    type = C_SETUID;
	  else if ((mode & S_ISGID) != 0)
	    type = C_SETGID;
	  else if ((mode & S_IXUGO) != 0)
	    type = C_EXEC;
	}
      else if (S_ISDIR (mode))
	{
	  if ((mode & S_ISVTX) && (mode & S_IWOTH))
	    type = C_STICKY_OTHER_WRITABLE;
	  else if ((mode & S_IWOTH) != 0)
	    type = C_OTHER_WRITABLE;
	  else if ((mode & S_ISVTX) != 0)
	    type = C_STICKY;
	  else
	    type = C_DIR;
	}
      else if (S_ISLNK (mode))
	type = ((!linkok && color_indicator[C_ORPHAN].string)
		? C_ORPHAN : C_LINK);
      else if (S_ISFIFO (mode))
	type = C_FIFO;
      else if (S_ISSOCK (mode))
	type = C_SOCK;
      else if (S_ISBLK (mode))
	type = C_BLK;
      else if (S_ISCHR (mode))
	type = C_CHR;
      else if (S_ISDOOR (mode))
	type = C_DOOR;
      else
	{
	  /* Classify a file of some other type as C_ORPHAN.  */
	  type = C_ORPHAN;
	}
    }

  /* Check the file's suffix only if still classified as C_FILE.  */
  ext = NULL;
  if (type == C_FILE)
    {
      /* Test if NAME has a recognized suffix.  */

      len = strlen (name);
      name += len;		/* Pointer to final \0.  */
      for (ext = color_ext_list; ext != NULL; ext = ext->next)
	{
	  if (ext->ext.len <= len
	      && strncmp (name - ext->ext.len, ext->ext.string,
			  ext->ext.len) == 0)
	    break;
	}
    }

  put_indicator (&color_indicator[C_LEFT]);
  put_indicator (ext ? &(ext->seq) : &color_indicator[type]);
  put_indicator (&color_indicator[C_RIGHT]);
}

/* Output a color indicator (which may contain nulls).  */
static void
put_indicator (const struct bin_str *ind)
{
  size_t i;
  const char *p;

  p = ind->string;

  for (i = ind->len; i != 0; --i)
    putchar (*(p++));
}

static size_t
length_of_file_name_and_frills (const struct fileinfo *f)
{
  size_t len = 0;
  size_t name_width;
  char buf[MAX (LONGEST_HUMAN_READABLE + 1, INT_BUFSIZE_BOUND (uintmax_t))];

  if (print_inode)
    len += 1 + (format == with_commas
		? strlen (umaxtostr (f->stat.st_ino, buf))
		: inode_number_width);

  if (print_block_size)
    len += 1 + (format == with_commas
		? strlen (human_readable (ST_NBLOCKS (f->stat), buf,
					  human_output_opts, ST_NBLOCKSIZE,
					  output_block_size))
		: block_size_width);

  if (print_scontext)
    len += 1 + (format == with_commas ? strlen (f->scontext) : scontext_width);

  quote_name (NULL, f->name, filename_quoting_options, &name_width);
  len += name_width;

  if (indicator_style != none)
    {
      char c = get_type_indicator (f->stat_ok, f->stat.st_mode, f->filetype);
      len += (c != 0);
    }

  return len;
}

static void
print_many_per_line (void)
{
  size_t row;			/* Current row.  */
  size_t cols = calculate_columns (true);
  struct column_info const *line_fmt = &column_info[cols - 1];

  /* Calculate the number of rows that will be in each column except possibly
     for a short column on the right.  */
  size_t rows = cwd_n_used / cols + (cwd_n_used % cols != 0);

  for (row = 0; row < rows; row++)
    {
      size_t col = 0;
      size_t filesno = row;
      size_t pos = 0;

      /* Print the next row.  */
      while (1)
	{
	  struct fileinfo const *f = sorted_file[filesno];
	  size_t name_length = length_of_file_name_and_frills (f);
	  size_t max_name_length = line_fmt->col_arr[col++];
	  print_file_name_and_frills (f);

	  filesno += rows;
	  if (filesno >= cwd_n_used)
	    break;

	  indent (pos + name_length, pos + max_name_length);
	  pos += max_name_length;
	}
      putchar ('\n');
    }
}

static void
print_horizontal (void)
{
  size_t filesno;
  size_t pos = 0;
  size_t cols = calculate_columns (false);
  struct column_info const *line_fmt = &column_info[cols - 1];
  struct fileinfo const *f = sorted_file[0];
  size_t name_length = length_of_file_name_and_frills (f);
  size_t max_name_length = line_fmt->col_arr[0];

  /* Print first entry.  */
  print_file_name_and_frills (f);

  /* Now the rest.  */
  for (filesno = 1; filesno < cwd_n_used; ++filesno)
    {
      size_t col = filesno % cols;

      if (col == 0)
	{
	  putchar ('\n');
	  pos = 0;
	}
      else
	{
	  indent (pos + name_length, pos + max_name_length);
	  pos += max_name_length;
	}

      f = sorted_file[filesno];
      print_file_name_and_frills (f);

      name_length = length_of_file_name_and_frills (f);
      max_name_length = line_fmt->col_arr[col];
    }
  putchar ('\n');
}

static void
print_with_commas (void)
{
  size_t filesno;
  size_t pos = 0;

  for (filesno = 0; filesno < cwd_n_used; filesno++)
    {
      struct fileinfo const *f = sorted_file[filesno];
      size_t len = length_of_file_name_and_frills (f);

      if (filesno != 0)
	{
	  char separator;

	  if (pos + len + 2 < line_length)
	    {
	      pos += 2;
	      separator = ' ';
	    }
	  else
	    {
	      pos = 0;
	      separator = '\n';
	    }

	  putchar (',');
	  putchar (separator);
	}

      print_file_name_and_frills (f);
      pos += len;
    }
  putchar ('\n');
}

/* Assuming cursor is at position FROM, indent up to position TO.
   Use a TAB character instead of two or more spaces whenever possible.  */

static void
indent (size_t from, size_t to)
{
  while (from < to)
    {
      if (tabsize != 0 && to / tabsize > (from + 1) / tabsize)
	{
	  putchar ('\t');
	  from += tabsize - from % tabsize;
	}
      else
	{
	  putchar (' ');
	  from++;
	}
    }
}

/* Put DIRNAME/NAME into DEST, handling `.' and `/' properly.  */
/* FIXME: maybe remove this function someday.  See about using a
   non-malloc'ing version of file_name_concat.  */

static void
attach (char *dest, const char *dirname, const char *name)
{
  const char *dirnamep = dirname;

  /* Copy dirname if it is not ".".  */
  if (dirname[0] != '.' || dirname[1] != 0)
    {
      while (*dirnamep)
	*dest++ = *dirnamep++;
      /* Add '/' if `dirname' doesn't already end with it.  */
      if (dirnamep > dirname && dirnamep[-1] != '/')
	*dest++ = '/';
    }
  while (*name)
    *dest++ = *name++;
  *dest = 0;
}

/* Allocate enough column info suitable for the current number of
   files and display columns, and initialize the info to represent the
   narrowest possible columns.  */

static void
init_column_info (void)
{
  size_t i;
  size_t max_cols = MIN (max_idx, cwd_n_used);

  /* Currently allocated columns in column_info.  */
  static size_t column_info_alloc;

  if (column_info_alloc < max_cols)
    {
      size_t new_column_info_alloc;
      size_t *p;

      if (max_cols < max_idx / 2)
	{
	  /* The number of columns is far less than the display width
	     allows.  Grow the allocation, but only so that it's
	     double the current requirements.  If the display is
	     extremely wide, this avoids allocating a lot of memory
	     that is never needed.  */
	  column_info = xnrealloc (column_info, max_cols,
				   2 * sizeof *column_info);
	  new_column_info_alloc = 2 * max_cols;
	}
      else
	{
	  column_info = xnrealloc (column_info, max_idx, sizeof *column_info);
	  new_column_info_alloc = max_idx;
	}

      /* Allocate the new size_t objects by computing the triangle
	 formula n * (n + 1) / 2, except that we don't need to
	 allocate the part of the triangle that we've already
	 allocated.  Check for address arithmetic overflow.  */
      {
	size_t column_info_growth = new_column_info_alloc - column_info_alloc;
	size_t s = column_info_alloc + 1 + new_column_info_alloc;
	size_t t = s * column_info_growth;
	if (s < new_column_info_alloc || t / column_info_growth != s)
	  xalloc_die ();
	p = xnmalloc (t / 2, sizeof *p);
      }

      /* Grow the triangle by parceling out the cells just allocated.  */
      for (i = column_info_alloc; i < new_column_info_alloc; i++)
	{
	  column_info[i].col_arr = p;
	  p += i + 1;
	}

      column_info_alloc = new_column_info_alloc;
    }

  for (i = 0; i < max_cols; ++i)
    {
      size_t j;

      column_info[i].valid_len = true;
      column_info[i].line_len = (i + 1) * MIN_COLUMN_WIDTH;
      for (j = 0; j <= i; ++j)
	column_info[i].col_arr[j] = MIN_COLUMN_WIDTH;
    }
}

/* Calculate the number of columns needed to represent the current set
   of files in the current display width.  */

static size_t
calculate_columns (bool by_columns)
{
  size_t filesno;		/* Index into cwd_file.  */
  size_t cols;			/* Number of files across.  */

  /* Normally the maximum number of columns is determined by the
     screen width.  But if few files are available this might limit it
     as well.  */
  size_t max_cols = MIN (max_idx, cwd_n_used);

  init_column_info ();

  /* Compute the maximum number of possible columns.  */
  for (filesno = 0; filesno < cwd_n_used; ++filesno)
    {
      struct fileinfo const *f = sorted_file[filesno];
      size_t name_length = length_of_file_name_and_frills (f);
      size_t i;

      for (i = 0; i < max_cols; ++i)
	{
	  if (column_info[i].valid_len)
	    {
	      size_t idx = (by_columns
			    ? filesno / ((cwd_n_used + i) / (i + 1))
			    : filesno % (i + 1));
	      size_t real_length = name_length + (idx == i ? 0 : 2);

	      if (column_info[i].col_arr[idx] < real_length)
		{
		  column_info[i].line_len += (real_length
					      - column_info[i].col_arr[idx]);
		  column_info[i].col_arr[idx] = real_length;
		  column_info[i].valid_len = (column_info[i].line_len
					      < line_length);
		}
	    }
	}
    }

  /* Find maximum allowed columns.  */
  for (cols = max_cols; 1 < cols; --cols)
    {
      if (column_info[cols - 1].valid_len)
	break;
    }

  return cols;
}

void
usage (int status)
{
  if (status != EXIT_SUCCESS)
    fprintf (stderr, _("Try `%s --help' for more information.\n"),
	     program_name);
  else
    {
      printf (_("Usage: %s [OPTION]... [FILE]...\n"), program_name);
      fputs (_("\
List information about the FILEs (the current directory by default).\n\
Sort entries alphabetically if none of -cftuvSUX nor --sort.\n\
\n\
"), stdout);
      fputs (_("\
Mandatory arguments to long options are mandatory for short options too.\n\
"), stdout);
      fputs (_("\
  -a, --all                  do not ignore entries starting with .\n\
  -A, --almost-all           do not list implied . and ..\n\
      --author               with -l, print the author of each file\n\
  -b, --escape               print octal escapes for nongraphic characters\n\
"), stdout);
      fputs (_("\
      --block-size=SIZE      use SIZE-byte blocks\n\
  -B, --ignore-backups       do not list implied entries ending with ~\n\
  -c                         with -lt: sort by, and show, ctime (time of last\n\
                               modification of file status information)\n\
                               with -l: show ctime and sort by name\n\
                               otherwise: sort by ctime\n\
"), stdout);
      fputs (_("\
  -C                         list entries by columns\n\
      --color[=WHEN]         control whether color is used to distinguish file\n\
                               types.  WHEN may be `never', `always', or `auto'\n\
  -d, --directory            list directory entries instead of contents,\n\
                               and do not dereference symbolic links\n\
  -D, --dired                generate output designed for Emacs' dired mode\n\
"), stdout);
      fputs (_("\
  -f                         do not sort, enable -aU, disable -ls --color\n\
  -F, --classify             append indicator (one of */=>@|) to entries\n\
      --file-type            likewise, except do not append `*'\n\
      --format=WORD          across -x, commas -m, horizontal -x, long -l,\n\
                               single-column -1, verbose -l, vertical -C\n\
      --full-time            like -l --time-style=full-iso\n\
"), stdout);
      fputs (_("\
  -g                         like -l, but do not list owner\n\
"), stdout);
      fputs (_("\
      --group-directories-first\n\
                             group directories before files\n\
"), stdout);
      fputs (_("\
  -G, --no-group             in a long listing, don't print group names\n\
  -h, --human-readable       with -l, print sizes in human readable format\n\
                               (e.g., 1K 234M 2G)\n\
      --si                   likewise, but use powers of 1000 not 1024\n\
"), stdout);
      fputs (_("\
  -H, --dereference-command-line\n\
                             follow symbolic links listed on the command line\n\
      --dereference-command-line-symlink-to-dir\n\
                             follow each command line symbolic link\n\
                             that points to a directory\n\
      --hide=PATTERN         do not list implied entries matching shell PATTERN\n\
                               (overridden by -a or -A)\n\
"), stdout);
      fputs (_("\
      --indicator-style=WORD  append indicator with style WORD to entry names:\n\
                               none (default), slash (-p),\n\
                               file-type (--file-type), classify (-F)\n\
  -i, --inode                print the index number of each file\n\
  -I, --ignore=PATTERN       do not list implied entries matching shell PATTERN\n\
  -k                         like --block-size=1K\n\
"), stdout);
      fputs (_("\
  -l                         use a long listing format\n\
  -L, --dereference          when showing file information for a symbolic\n\
                               link, show information for the file the link\n\
                               references rather than for the link itself\n\
  -m                         fill width with a comma separated list of entries\n\
"), stdout);
      fputs (_("\
  -n, --numeric-uid-gid      like -l, but list numeric user and group IDs\n\
  -N, --literal              print raw entry names (don't treat e.g. control\n\
                               characters specially)\n\
  -o                         like -l, but do not list group information\n\
  -p, --indicator-style=slash\n\
                             append / indicator to directories\n\
"), stdout);
      fputs (_("\
  -q, --hide-control-chars   print ? instead of non graphic characters\n\
      --show-control-chars   show non graphic characters as-is (default\n\
                             unless program is `ls' and output is a terminal)\n\
  -Q, --quote-name           enclose entry names in double quotes\n\
      --quoting-style=WORD   use quoting style WORD for entry names:\n\
                               literal, locale, shell, shell-always, c, escape\n\
"), stdout);
      fputs (_("\
  -r, --reverse              reverse order while sorting\n\
  -R, --recursive            list subdirectories recursively\n\
  -s, --size                 print the size of each file, in blocks\n\
"), stdout);
      fputs (_("\
  -S                         sort by file size\n\
      --sort=WORD            sort by WORD instead of name: none -U,\n\
                             extension -X, size -S, time -t, version -v\n\
      --time=WORD            with -l, show time as WORD instead of modification\n\
                             time: atime -u, access -u, use -u, ctime -c,\n\
                             or status -c; use specified time as sort key\n\
                             if --sort=time\n\
"), stdout);
      fputs (_("\
      --time-style=STYLE     with -l, show times using style STYLE:\n\
                             full-iso, long-iso, iso, locale, +FORMAT.\n\
                             FORMAT is interpreted like `date'; if FORMAT is\n\
                             FORMAT1<newline>FORMAT2, FORMAT1 applies to\n\
                             non-recent files and FORMAT2 to recent files;\n\
                             if STYLE is prefixed with `posix-', STYLE\n\
                             takes effect only outside the POSIX locale\n\
"), stdout);
      fputs (_("\
  -t                         sort by modification time\n\
  -T, --tabsize=COLS         assume tab stops at each COLS instead of 8\n\
"), stdout);
      fputs (_("\
  -u                         with -lt: sort by, and show, access time\n\
                               with -l: show access time and sort by name\n\
                               otherwise: sort by access time\n\
  -U                         do not sort; list entries in directory order\n\
  -v                         sort by version\n\
"), stdout);
      fputs (_("\
  -w, --width=COLS           assume screen width instead of current value\n\
  -x                         list entries by lines instead of by columns\n\
  -X                         sort alphabetically by entry extension\n\
  -Z, --context              print any SELinux security context of each file\n\
  -1                         list one file per line\n\
"), stdout);
      fputs (HELP_OPTION_DESCRIPTION, stdout);
      fputs (VERSION_OPTION_DESCRIPTION, stdout);
      fputs (_("\n\
SIZE may be (or may be an integer optionally followed by) one of following:\n\
kB 1000, K 1024, MB 1000*1000, M 1024*1024, and so on for G, T, P, E, Z, Y.\n\
"), stdout);
      fputs (_("\
\n\
By default, color is not used to distinguish types of files.  That is\n\
equivalent to using --color=none.  Using the --color option without the\n\
optional WHEN argument is equivalent to using --color=always.  With\n\
--color=auto, color codes are output only if standard output is connected\n\
to a terminal (tty).  The environment variable LS_COLORS can influence the\n\
colors, and can be set easily by the dircolors command.\n\
"), stdout);
      fputs (_("\
\n\
Exit status is 0 if OK, 1 if minor problems, 2 if serious trouble.\n\
"), stdout);
      emit_bug_reporting_address ();
    }
  exit (status);
}
