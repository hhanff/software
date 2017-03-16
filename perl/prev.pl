#! /usr/bin/perl
#                                   prev.pl
#                                   Version 1.0
#                                   17 Dec 2002, SD
#                                   www.doulos.com
#
# Copyright (c) 2002, Doulos Limited
# Training and consultancy for hardware engineers.
#
# Debug Perl Regular Expressions using this powerful
# Perl/Tk application.
#
# This application requires Perl 5.6 (or newer) interpreter.

# 14 Oct 2004 - Used eval instead of starting separate Perl interpreter

use Tk;

setup_main_window();
any_changes();
$main_window->after( 500, \&update );

MainLoop;

sub setup_main_window {
  $main_window = MainWindow->new;
  $main_window->title( "Perl Regular Expression Viewer - Doulos Limited" );
  $font = 'Courier';

  $frame_operation = $main_window->Frame( -borderwidth => 2, -relief => 'groove' );
  $frame_string    = $main_window->Frame( -borderwidth => 2, -relief => 'groove' );
  $frame_pattern   = $main_window->Frame( -borderwidth => 2, -relief => 'groove' );
  $frame_results   = $main_window->Frame( -borderwidth => 2, -relief => 'groove' );

  $frame_operation->pack( -side => 'top', -padx => 2, -pady => 2, -anchor => 'n', -expand => 0, -fill => 'x'    );
  $frame_string   ->pack( -side => 'top', -padx => 2, -pady => 2, -anchor => 'n', -expand => 0, -fill => 'x'    );
  $frame_pattern  ->pack( -side => 'top', -padx => 2, -pady => 2, -anchor => 'n', -expand => 0, -fill => 'x'    );
  $frame_results  ->pack( -side => 'top', -padx => 2, -pady => 2, -anchor => 'n', -expand => 1, -fill => 'both' );

  # operation frame
  $operation_var = 'scalar';
  $operation_scalar = $frame_operation->Radiobutton( -variable => \$operation_var, -font => $font, -value => 'scalar', -text => 'Match (Scalar)'  );
  $operation_list   = $frame_operation->Radiobutton( -variable => \$operation_var, -font => $font, -value => 'list',   -text => 'Match (List)'    );
  $operation_split  = $frame_operation->Radiobutton( -variable => \$operation_var, -font => $font, -value => 'split',  -text => 'Split' );

  $operation_scalar->pack( -side => 'left', -padx => 2, -pady => 2 );
  $operation_list  ->pack( -side => 'left', -padx => 2, -pady => 2 );
  $operation_split ->pack( -side => 'left', -padx => 2, -pady => 2 );

  # string frame
  $string_label     = $frame_string->Label( -font => $font, -text => '$string =' );
  $string_text      = $frame_string->Text(  -font => $font, -height => 5 );
  $string_scrollbar = $frame_string->Scrollbar( -orient => 'vertical', -command => [ 'yview' => $string_text ] );
  $string_text     ->configure( -yscrollcommand => [ 'set' => $string_scrollbar ] );

  $string_label    ->pack( -side => 'left',  -padx => 2, -pady => 2, -fill => 'none', -anchor => 'nw' );
  $string_text     ->pack( -side => 'left',  -padx => 2, -pady => 2, -fill => 'both', -expand => 1 );
  $string_scrollbar->pack( -side => 'right', -padx => 2, -pady => 2, -fill => 'y',    -expand => 0 );

  # pattern frame
  $pattern_label     = $frame_pattern->Label( -font => $font, -text => 'Pattern' );
  $pattern_entry     = $frame_pattern->Entry( -font => $font, -textvariable => \$pattern_var );
  $pattern_mod_label = $frame_pattern->Label( -font => $font, -text => 'Modifiers' );
  $pattern_mod_entry = $frame_pattern->Entry( -font => $font, -textvariable => \$modifiers_var, -width => 5 );

  $pattern_label    ->pack( -side => 'left', -padx => 2, -pady => 2 );
  $pattern_entry    ->pack( -side => 'left', -padx => 2, -pady => 2, -fill => 'x', -expand => 1 );
  $pattern_mod_label->pack( -side => 'left', -padx => 2, -pady => 2 );
  $pattern_mod_entry->pack( -side => 'left', -padx => 2, -pady => 2 );

  # results frame
  $results_label =     $frame_results->Label( -font => $font, -textvariable => \$perl_command_label, -fg => '#000099' );
  $results_text  =     $frame_results->Text(  -font => $font, -height => 19 );
  $results_scrollbar = $frame_results->Scrollbar( -orient => 'vertical', -command => [ 'yview' => $results_text ] );
  $results_text->configure( -yscrollcommand => [ $results_scrollbar => 'set' ] );

  $results_label->    pack( -side => 'top',   -padx => 2, -pady => 2 );
  $results_scrollbar->pack( -side => 'right', -padx => 2, -pady => 2, -fill => 'y' );
  $results_text     ->pack( -side => 'left',  -padx => 2, -pady => 2, -fill => 'both', -expand => 1 );

  $results_text->tagConfigure( 'red', foreground => 'red' );

  $results_text->insert( 'end', '
    Perl Regular Expression Viewer
    ==============================
    Copyright (c) 2002, Doulos Limited

    Doulos is the leader for independent know-how in leading edge methodologies
    for SoC, FPGA/CPLD and ASIC design. Our in-house expertise supports training
    and project services in VHDL,Verilog®, SystemCTM, Handel-C, Perl, Tcl/Tk, e
    and design verification. The ideal design know-how partner, Doulos continues
    to build on its decade strong reputation as the essential choice for over
    600 companies in more than 14 countries.
    
    How To Use
    ==========
    Choose whether you want to develop a regular expression for the pattern match
    operation (scalar or list context) or the split operation. Click the
    appropriate radio button.
    
    Type or paste the string you wish to match or split into the text area
    labelled $string =.
    
    Type your regular expression into the entry field labelled Pattern using any
    valid regular expression syntax.
    
    Type letters for any modifiers you want to use into the field labelled
    Modifiers. For example, i for ignore case and g for global.

    To improve useability and productivity results are automatically updated every
    500 ms when changes have been made to the input fields.
    
    This script creates another Perl script called perl_script.pl which is then
    executed like this:
    
      $result_text = qx/perl perl_script.pl/;

    This application must have permission to write and read files in its working
    directory. The Perl interpreter must be in the path environment variable.
    
    Return values for $result or @result (as appropriate) and all the relevant
    back reference matches are displayed. Perl interpreter errors are displayed
    in this window too.
    
    Temporary errors are bound to occur as you develop your regular expressions.
    For example an open bracket must be typed to begin a grouping but that is an
    error until the closing bracket is typed.

    Regular expressions are a core component of the powerful Perl text processing
    language. Every hardware engineer must be thoroughly conversant with them to
    maximise their productivity.

    This viewer is proving to be an extremely valuable tool among our customers and
    especially delegates attending our Essential Perl courses.
    
    Simon Dempsey
    17 December  2002
' );
  print "Main window is now set up.\n";
}

sub any_changes {
  chomp( $string_var = $string_text->get( '1.0', 'end' ) );
  $old_data = $new_data;
  $new_data = "$string_var$pattern_var$operation_var$modifiers_var";
  return $old_data ne $new_data;
}

sub update {
  if( any_changes() ) {
    $regex_result = '';
    $string_var_escaped = $string_var;
    $string_var_escaped =~ s/\\/\\\\/g;
    $string_var_escaped =~ s/'/\\'/g;
    if( $operation_var eq 'scalar' ) {
      $perl_command_label = "\$result = \$string =~ /$pattern_var/$modifiers_var";
      $perl_script = <<EOF;
if( \$result = '$string_var_escaped' =~ /$pattern_var/$modifiers_var ) {
  \$regex_result .= "\\\$result = \$result\\n";
  foreach( 1..9 ) {
    if( \$val = eval "\$\$_" ) {
      \$regex_result .= "\\n" unless \$count++;
      \$regex_result .= "\\\$\$_ = '\$val'\\n";
    }
  }
  \$regex_result .= "\\n\\\$` = '\$`'\\n";
  \$regex_result .= "\\\$& = '\$&'\\n";
  \$regex_result .= "\\\$' = '\$''\\n";
  \$regex_result .= "\\\$+ = '\$+'\\n";
}
else { \$regex_result = "No match\\n" }
EOF
    }
    elsif( $operation_var eq 'list' ) {
      $perl_command_label = "\@result = \$string =~ /$pattern_var/$modifiers_var";
      $perl_script = <<EOF;
if( \@result = '$string_var_escaped' =~ /$pattern_var/$modifiers_var ) {
  foreach( 0..\$#result ) {
    \$regex_result .= "\\\$result[\$_] = '\$result[\$_]'\\n";
  }
  foreach( 1..9 ) {
    if( \$val = eval "\$\$_" ) {
      \$regex_result .= "\\n" unless \$count++;
      \$regex_result .= "\\\$\$_ = '\$val'\\n";
    }
  }
  \$regex_result .= "\\n\\\$` = '\$`'\\n";
  \$regex_result .= "\\\$& = '\$&'\\n";
  \$regex_result .= "\\\$' = '\$''\\n";
  \$regex_result .= "\\\$+ = '\$+'\\n";
}
else { \$regex_result .= "No match\\n" }
EOF
}
    elsif( $operation_var eq 'split' ) {
      $perl_command_label = "\@result = split( /$pattern_var/$modifiers_var, \$string )";
      $perl_script = <<EOF;
\@result = split( /$pattern_var/$modifiers_var, '$string_var_escaped' );
if( \$#result >= 0 ) {
  foreach( 0..\$#result ) {
    \$regex_result .= "\\\$result[\$_] = '\$result[\$_]'\\n";
  }
}
else { \$regex_result .= "\\\@results = ()\\n" }
EOF
    }
    $results_text->delete( '0.0', 'end' );
    eval $perl_script;
    if( $@ ) {
      $results_text->insert( 'end', $@, 'red' );
    } else {
      $results_text->insert( 'end', $regex_result );
    }
  }
  $main_window->after( 500, \&update );
}
