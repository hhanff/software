 ;;; package --- Summary
 ;;; Commentary: Personal init file of Hendrik Hanff

 (setq toggle-bug-on-error t)
 ;;(setq stack-trace-on-error t)
 (load "server")

 ;; (unless (server-running-p) (server-start))
 ;; https://robal.wordpress.com/2016/09/01/removing-emacs-server-file-on-startup/
 (cond ((eq (server-running-p) nil)
        (progn (message "Starting new server.") (server-start)))
       ((eq (server-running-p) :other)
        (let ((my-status 0)) (ignore-errors (setq my-status (server-eval-at server-name (+ 1 1))))
             (if (/= my-status 2) (progn
                                    (message "Killing stale socket and starting server.")
                                    (server-force-delete)
                                    (server-start))
               (message "Other server works."))))
       (t (message "Server already started.")))
 ;;------------------------------------------------------------------------------
 ;; Package stuff
 ;;------------------------------------------------------------------------------
 (require 'package)
 (setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("melpa" . "http://melpa.org/packages/")
                          ("SC"  . "http://joseito.republika.pl/sunrise-commander/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")))

 (package-initialize)

(defvar my-packages
  '(scpaste ispell
            ;;starter-kit
            ;;starter-kit-lisp
            ;;starter-kit-bindings
            ;;marmalade
            use-package
            counsel
            bind-key
            rainbow-delimiters
            markdown-mode
            guru-mode
            company
            web-mode
            mew
            helm
            smex
            auto-complete
            dtrt-indent
            google-c-style
            highline
            indent-guide
            highlight-indentation
            iedit
            flymake-google-cpplint
            yasnippet
            flycheck
            ;;flycheck-google-cpplint
            auto-complete-c-headers
            flymake-cursor
            dash
            which-key
            gist
            magit
            auctex
            auto-complete-auctex
            ;;color-theme-solarized
            keyfreq
            theme-changer
            dumb-jump
            elpy
            py-autopep8
            git-gutter
            )
  (when (not package-archive-contents)
    (package-refresh-contents)))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

 ; start auto-complete with emacs
 (require 'auto-complete)
 ; do default config for auto-complete
 (require 'auto-complete-config)
 (ac-config-default)

 (require 'yasnippet)
 (yas-global-mode 1)
 ;;Fix iedit bug in Mac
 (define-key global-map (kbd "C-c ;") 'iedit-mode)

 ; start flymake-google-cpplint-load
 ; let's define a function for flymake initialization
 (defun my:flymake-google-init ()
   (require 'flymake-google-cpplint)
    ;; To make this work do
    ;; > sudo apt-get install python-pip; sudo pip install cpplint;
    ;; > cd /usr/local/lib/python2.7/dist-packages;  sudo chmod -R 777;
   (custom-set-variables
    '(flymake-google-cpplint-linelength "120")
    '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
   (flymake-google-cpplint-load))
 (add-hook 'c-mode-hook 'my:flymake-google-init)
 (add-hook 'c++-mode-hook 'my:flymake-google-init)

 ;;(eval-after-load 'flycheck
 ;;    '(progn
 ;;       (require 'flycheck-google-cpplint)
 ;;       ;; Add Google C++ Style checker.
 ;;       ;; In default, syntax checked by Clang and Cppcheck.
 ;;       (flycheck-add-next-checker 'c/c++-cppcheck
 ;;                                  '(info . c/c++-googlelint))))

 ; turn on Semantic
 (semantic-mode 1)
 ; let's define a function which adds semantic as a suggestion backend to auto complete
 ; and hook this function to c-mode-common-hook
 (defun my:add-semantic-to-autocomplete()
   (add-to-list 'ac-sources 'ac-source-semantic)
   )
 (global-semantic-idle-scheduler-mode 1)

 (add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
 ; turn on ede mode
 (global-ede-mode 1)
 ; create a project for our program.
 ;; (ede-cpp-root-project "my project" :file "~/demos/my_program/src/main.cpp"
 ;; 		      :include-path '("/../my_inc"))
 ; you can use system-include-path for setting up the system header file locations.
 ; turn on automatic reparsing of open buffers in semantic
 (global-semantic-idle-scheduler-mode 1)

(setq yas/root-directory "~/.emacs.d/snippets")
;;(yas/load-directory yas/root-directory)
;;(require 'yasnippet-bundle)
;; Completing point by some yasnippet key
(defun yas-ido-expand ()
   "Lets you select (and expand) a yasnippet key"
   (interactive)
   (let ((original-point (point)))
     (while (and
             (not (= (point) (point-min) ))
             (not
              (string-match "[[:space:]\n]" (char-to-string (char-before)))))
       (backward-word 1))
     (let* ((init-word (point))
            (word (buffer-substring init-word original-point))
            (list (yas-active-keys)))
       (goto-char original-point)
       (let ((key (remove-if-not
                   (lambda (s) (string-match (concat "^" word) s)) list)))
         (if (= (length key) 1)
             (setq key (pop key))
           (setq key (ido-completing-read "key: " list nil nil word)))
         (delete-char (- init-word original-point))
         (insert key)
         (yas-expand)))))

;; When yas/minor-mode is activated in a term/ansi-term buffer, pressing tab
;; results in the following error:
;;      term-send-raw: Wrong type argument: characterp, tab.
;; This fixes the error.
(add-hook 'term-mode-hook (lambda()
                            (yas-minor-mode -1)))

 (define-key yas-minor-mode-map (kbd "<C-tab>")     'yas-ido-expand)
 ;; ;; If yas is not working with vhdl mode, try
 ;; cd ~/.emacs.d/elpa/yasnippet*/snippets
 ;; mkdir vhdl-mode; cd vhdl-mode
 ;; echo "prog-mode" >> .yas-parents

 ;; C/C++ style stuff
 ;; Other styles: k&r, bsd, gnu, whitesmith, stroustroup...
 (setq c-default-style "linux"
       c-basic-offset 4)
 ; let's define a function which initializes auto-complete-c-headers and gets called for c/c++ hooks
 (defun my:ac-c-header-init ()
   (require 'auto-complete-c-headers)
   (add-to-list 'ac-sources 'ac-source-c-headers)
 )
 ; now let's call this function from c/c++ hooks
 (add-hook 'c++-mode-hook 'my:ac-c-header-init)
 (add-hook 'c-mode-hook 'my:ac-c-header-init)


 ;; (require 'doxymacs)
 ;; (add-hook 'c-mode-common-hook'doxymacs-mode)
 ;; ;; Doxygen keywords fontified
 ;; (defun my-doxymacs-font-lock-hook ()
 ;;   (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
 ;;       (doxymacs-font-lock)))
 ;; (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

 ;; ; Fix iedit bug in Mac
 ;; (define-key global-map (kbd "C-c ;") 'iedit-mode)

 ;; Start Google C-Style with emacs
 (require 'google-c-style)
 (add-hook 'c-mode-common-hook 'google-set-c-style)
 (add-hook 'c-mode-common-hook 'google-make-newline-indent)

 ;;------------------------------------------------------------------------------
 ;;    General settings (optional)
 ;;------------------------------------------------------------------------------
 (setq user-mail-address "hendrik.hanff@dfki.de" )

 ;; This line makes copy paste work under Ubuntu
 (setq x-select-enable-clipboard t)

 ; Make Emacs UTF-8 compatible for both display and editing:
 (prefer-coding-system 'utf-8)
 (set-terminal-coding-system 'utf-8)
 (set-keyboard-coding-system 'utf-8)

 ; Turn off abbrev mode
 (abbrev-mode 0)

 ; Set very handy ido mode to switch buffers with C-x b and cycling
 ; through them with cursor keys or specifying the buffer name by typing its name
 (ido-mode 'buffer)
 ;; Remove completion buffer when done
 (add-hook 'minibuffer-exit-hook
       '(lambda ()
          (let ((buffer "*Completions*"))
            (and (get-buffer buffer)
             (kill-buffer buffer)))))

 ; truncate long lines in buffers and prevent wrapping them
 (setq truncate-lines 1)

 (setq line-number-display-limit 16000000) ; line numbers in long files
 (setq inhibit-startup-message   t)   ; Don't want any startup message
 (setq auto-save-list-file-name  nil) ; Don't want any .saves files
 (setq auto-save-default         nil) ; Don't want any auto saving
 ;; Enable backup files.
 (setq make-backup-files t)
 ;; Enable versioning with default values (keep five last versions, I think!)
 (setq version-control t)
 ;; Save all backup file in this directory.
 (setq backup-directory-alist (quote ((".*" . "/tmp/emacs_backup_files"))))

 ; Set path of file for frame title
 (setq frame-title-format
   '("%S: " (buffer-file-name "%f"
                              (dired-directory dired-directory "%b"))))

 ;;(require 'icicles)
 ;;(icy-mode 1)

 (require 'keyfreq)
 (setq keyfreq-excluded-commands
       '(self-insert-command
         abort-recursive-edit
         previous-line
         next-line))
 (keyfreq-mode 1)
 (keyfreq-autosave-mode 1)

 ;; Emacs will not automatically add new lines
 (setq next-line-add-newlines nil)
 ;; something else that should make scrolling nicer
 (setq scroll-conservatively 1)
 (setq scroll-step 0)

 ;; replace yes or no with y or n
 (fset 'yes-or-no-p 'y-or-n-p)

 (display-time)                                          ; Display the time

 ;; M-q : Automatisch den Text nach 80 Zeichen umbrechen
 ;; C-u M-q: Wie oben, nur Blockmode
 ;; C-o: harte neue Zeile die bestehen bleibt
 (setq-default fill-column 80)
 (add-hook 'text-mode-hook'(lambda () (auto-fill-mode 1)))
 (add-hook 'text-mode-hook 'turn-on-auto-fill)

 ;; Fill and unfill paragraphs with a single key
 (defun endless/fill-or-unfill ()
   "Like `fill-paragraph', but unfill if used twice."
   (interactive)
   (let ((fill-column
          (if (eq last-command 'endless/fill-or-unfill)
              (progn (setq this-command nil)
                     (point-max))
            fill-column)))
     (call-interactively #'fill-paragraph)))

 (global-set-key [remap fill-paragraph]
                 #'endless/fill-or-unfill)

 (add-hook 'LaTeX-mode-hook '(lambda ()
                              (setq auto-fill-function 'LaTeX-fill-paragraph)))

 (setq Tex-PDF-mode t)
 ;; (require 'tex)
 ;;   (TeX-global-PDF-mode t)
 ;; (setq-default auto-fill-hook 'do-auto-fill) (add-hook 'text-mode-hook
 ;; 'turn-on-auto-fill) (setq-default auto-fill-function 'do-auto-fill) (autoload
 ;; 'longlines-mode "longlines.el" "Minor mode for automatically wrapping long
 ;; lines." t)
 (setq TeX-auto-save t)
 (setq TeX-parse-self t)
 (setq TeX-save-query nil)


 (put 'eval-expression 'disabled nil)

 ; I do not need the toolbar 'cause it only wastes space
 (tool-bar-mode -1)

 ; This is potentially dangerous. When reverting files via SVN it might
 ; occasionally occur that files were reverted which I would have liked to keep.
 ; Therefore turn this off to keep the buffers as backup files.
 (global-auto-revert-mode nil)

 ;; When running clean-buffer-list, only buffers are killed which were not used
 ;; within the last 30 days
 ;(setq clean-buffer-list-delay-general 30)

 ;; Desktop saving
 (require 'desktop)
 ;; save a bunch of variables to the desktop file
 ;; for lists specify the len of the maximal saved data also
 (setq desktop-globals-to-save
       (append '((extended-command-history . 300)
                 (file-name-history        . 100)
                 (grep-history             . 30)
                 (compile-history          . 30)
                 (minibuffer-history       . 5000)
                 (query-replace-history    . 60)
                 (read-expression-history  . 60)
                 (regexp-history           . 60)
                 (regexp-search-ring       . 20)
                 (search-ring              . 2000)
                 (shell-command-history    . 50)
                 tags-file-name
                 register-alist)))
(setq delete-old-versions t)
 (setq desktop-path '("~/.emacs.d/desktop"))
 (setq desktop-dirname "~/.emacs.d/desktop")
 (setq desktop-base-file-name "emacs-desktop")
 (desktop-save-mode 1)

(setq delete-old-versions t)
 ;; Functions needed for global / gtags
 (autoload 'gtags-mode "gtags" "" t)

 ;; Duplicate line with C-D
 (defun duplicate-line()
   (interactive)
   (move-beginning-of-line 1)
   (kill-line)
   (yank)
   (open-line 1)
   (forward-line 1)
   (yank)
   )
 (global-set-key (kbd "C-S-d") 'duplicate-line)

;; (require 'ascope)
 (defun chomp (str)
   "Chomp leading and tailing whitespace from STR."
   (replace-regexp-in-string (rx (or (: bos (* (any " \t\n")))
                                     (: (* (any " \t\n")) eos)))
                             ""
                             str))

 (delete-selection-mode t) ; replaces selection
 (setq user-full-name "Hendrik Hanff"
       user-mail-address "hendrik.hanff@googlemail.com")

 ;; (load "/usr/share/emacs23/site-lisp/auct ex.el" nil t t)
 ;; (load "/usr/share/emacs23/site-lisp/preview-latex.el" nil t)
 ;; (load "preview-latex.el" nil t t)
 ;; Da ist ein "Newline in der Zeile!"
 (setq sentence-end "[.?!][]\"’)}]*\\($\\| \\| \\)[;;]*")
 (add-hook 'doc-view-mode-hook 'auto-revert-mode)(setq sentence-end-double-space nil)
 ;; (pdf-tools-install)

 ;; sudo apt-get install aspell aspell-de
 ;; aspell ist besser als ispell.
 ;; Zeile kommentieren, falls nicht installiert:
 (setq ispell-program-name "aspell") ; could be ispell as well, depending on your preferences
 (setq ispell-dictionary "english") ; this can obviously be set to any language your spell-checking program supports

 (require 'tex-site)
 (autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
 (autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
 (autoload 'reftex-citation "reftex-cite" "Make citation" nil)
 (autoload 'reftex-index-phrase-mode "reftex-index" "Phrase Mode" t)
 (add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
 ;; (add-hook 'reftex-load-hook 'imenu-add-menubar-index)
 (add-hook 'LaTeX-mode-hook 'turn-on-reftex)

 (setq LaTeX-eqnarray-label "eq"
       LaTeX-equation-label "eq"
       LaTeX-figure-label "fig"
       LaTeX-table-label "tab"
       LaTeX-myChapter-label "chap"
       TeX-auto-save t
       TeX-newline-function 'reindent-then-newline-and-indent
       TeX-parse-self t
       TeX-style-path
       '("style/" "auto/"
         "/usr/share/emacs21/site-lisp/auctex/style/"
         "/var/lib/auctex/emacs21/"
         "/usr/local/share/emacs/site-lisp/auctex/style/")
       LaTeX-section-hook
       '(LaTeX-section-heading
         LaTeX-section-title
         LaTeX-section-toc
         LaTeX-section-section
         LaTeX-section-label))

 (add-hook 'LaTeX-mode-hook 'flyspell-mode)
 (add-hook 'LaTeX-mode-hook 'flyspell-buffer)

 ;; Deutsche Rechtschreibung falls \usepackage{ngerman}
 ;; oder german benutzt wird
 (add-hook 'TeX-language-de-hook
           (function (lambda () (ispell-change-dictionary "german8"))))

 ; Ispell wird im ''Text Modus'' waerend dem eigentlichen schreiben verwendet und muss nicht manuell
 ; gestartet werden.
 (add-hook 'text-mode-hook 'flyspell-mode)

 ;; To set the buffer encoding to iso8889-15:
 ;; M-x set-buffer-file-coding-system iso%-*- coding: iso-8859-15 -*-
 ;; This is mandatory for LIMES Workpackage documentation and LIMES quarter
 ;; report
 ;; Alternativ an den Anfang der Datei die Zeile
 ;; %-*- coding: utf-8 -*-
 ;; eingügen
 ;;(modify-coding-system-alist 'file "\\.tex\\'" 'iso-8859-15)
 (modify-coding-system-alist 'file "\\.tex\\'" 'utf-8)
 (setq TeX-PDF-mode t)
 (defadvice kill-ring-save (before slick-copy activate compile)
   "When called interactively with no active region, copy the current line."
   (interactive
    (if mark-active
        (list (region-beginning) (region-end))
      (progn
        (message "Current line is copied.")
        (list (line-beginning-position) (line-beginning-position 2)) ) ) ))

 (defadvice kill-region (before slick-copy activate compile)
   "When called interactively with no active region, cut the current line."
   (interactive
    (if mark-active
        (list (region-beginning) (region-end))
      (progn
        (list (line-beginning-position) (line-beginning-position 2)) ) ) ))

 (require 'undo-tree)
 (setq undo-tree-auto-save-history nil)
 (setq undo-tree-visualizer-timestamps t)
 (setq undo-tree-visualizer-diff t)
 (global-undo-tree-mode)
 (global-set-key (kbd "C-S-_") 'undo-tree-visualize)

 ;;------------------------------------------------------------------------------
 ;;    Base settings and naming convention
 ;;------------------------------------------------------------------------------
 (custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(column-number-mode t)
  '(custom-safe-themes (quote ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
  '(ecb-auto-compatibility-check 0)
  '(ecb-auto-update-methods-after-save t)
  '(ecb-cache-directory-contents nil)
  '(ecb-expand-methods-buffer all)
  '(ecb-gzip-setup (quote cons))
  ;; '(ecb-layout-name "")
  '(ecb-options-version "2.40")
  '(ecb-show-tags (quote ((default (include expanded name) (parent expanded name) (type expanded name) (variable expanded name) (function expanded name) (label expanded name) (t expanded name)) (c++-mode (include collapsed nil) (parent collapsed nil) (type flattened nil) (variable collapsed access) (function flattened access) (function collapsed access) (label hidden nil) (t collapsed nil)) (c-mode (include collapsed nil) (parent collapsed nil) (type flattened nil) (variable collapsed access) (function flattened access) (function collapsed access) (label hidden nil) (t collapsed nil)) (bovine-grammar-mode (keyword collapsed name) (token collapsed name) (nonterminal flattened name) (rule flattened name) (t collapsed nil)) (wisent-grammar-mode (keyword collapsed name) (token collapsed name) (nonterminal flattened name) (rule flattened name) (t collapsed nil)) (texinfo-mode (section flattened nil) (def collapsed name) (t collapsed nil)) (lua-mode (t expanded name) (function collapsed name)))))
  '(ecb-source-path (quote ("~/Projekte/FPGA/")))
  '(ecb-tar-setup (quote cons))
  '(ecb-tip-of-the-day nil)
  '(ecb-tree-expand-symbol-before t)
  '(ecb-tree-indent 4)
  '(ecb-version-check nil)
  '(ecb-wget-setup (quote cons))
  '(ede-project-directories (quote ("/home/hhanff/sat" "/tmp")))
  '(global-font-lock-mode t nil (font-lock))
  '(line-number-mode 1)
  '(load-home-init-file t t)
  '(mouse-scroll-delay 0)
  '(org-agenda-files (quote ("~/.emacs.d/org/main.org")))
  '(org-agenda-ndays 7)
  '(org-agenda-restore-windows-after-quit t)
  '(org-agenda-show-all-dates t)
  '(org-agenda-skip-deadline-if-done t)
  '(org-agenda-skip-scheduled-if-done t)
  '(org-agenda-start-on-weekday nil)
  '(org-agenda-todo-ignore-deadlines t)
  '(org-agenda-todo-ignore-scheduled t)
  '(org-agenda-todo-ignore-with-date t)
  '(org-agenda-window-setup (quote other-window))
  '(org-deadline-warning-days 7)
  '(org-fast-tag-selection-single-key nil)
  '(org-log-done (quote (done)))
  '(org-refile-targets (quote (("newgtd.org" :maxlevel . 1) ("someday.org" :level . 2))))
  '(org-reverse-note-order nil)
  '(org-tags-column -78)
  '(org-tags-match-list-sublevels nil)
  '(org-use-fast-todo-selection t)
  '(org-use-tag-inheritance nil)
  '(ps-paper-type (quote a4))
  '(ps-print-color-p nil)
  '(show-paren-mode t)
  '(vhdl-clock-edge-condition (quote function))
  '(vhdl-clock-name "clk_s")
  '(vhdl-clock-rising-edge (quote f))
  '(vhdl-company-name "DFKI - Deutsches Forschungszentrum für künstliche Intelligenz")
  '(vhdl-directive-keywords (quote ("pragma" "synopsys" "synthesis")))
  '(vhdl-electric-mode t)
  '(vhdl-end-comment-column 280)
  '(vhdl-highlight-case-sensitive t)
  '(vhdl-highlight-keywords t)
  '(vhdl-highlight-signals t)
  '(vhdl-highlight-special-words t)
  '(vhdl-highlight-translate-off t)
  '(vhdl-index-menu t)
  '(vhdl-platform-spec "Xilinx")
  '(vhdl-project "DFKI FPGA")
  '(vhdl-project-alist (quote (("DFKI FPGA" "DFKIs FPGA svn" "~/Projekte/FPGA/" ("-r lib/" "-r designs/") "" (("ModelSim" "-87 \\2" "-f \\1 top_level" nil) ("Synopsys" "-vhdl87 \\2" "-f \\1 top_level" ((".*/datapath/.*" . "-optimize \\3") (".*_tb\\.vhd")))) ""))))
  '(vhdl-reset-active-high t)
  '(vhdl-reset-kind (quote sync))
  '(vhdl-reset-name "rst_s")
  '(vhdl-special-syntax-alist (quote (("constant" "[A-Z][A-Z0-9]_C" "Gold3" "BurlyWood1") ("signal-clock" "clk_+\\w" "LimeGreen" "Green") ("signal-reset" "rst_+\\w" "Tomato" "Coral") ("signal-enable" "[A-Z][A-Za-z0-9]*xE[A-Za-z0-9]*" "LightSeaGreen" "AquaMarine2") ("signal-control" "[A-Z][A-Za-z0-9]*xS[A-Za-z0-9]*" "DodgerBlue" "LightSkyBlue1") ("signal-data" "[A-Z][A-Za-z0-9]*xD[A-Za-z0-9]*" "Grey40" "Grey80") ("signal-test" "[A-Z][A-Za-z0-9]*xT[A-Za-z0-9]*" "Gold" "Yellow") ("signal-async" "[A-Z][A-Za-z0-9]*xA[A-Za-z0-9]*" "PaleVioletRed" "PaleVioletRed1") ("signal-3state" "[A-Z][A-Za-z0-9]*xZ[A-Za-z0-9]*" "Grey70" "Grey70"))))
  '(vhdl-speedbar-auto-open nil)
  '(vhdl-speedbar-display-mode (quote project))
  '(vhdl-speedbar-show-hierarchy t)
  '(vhdl-standard (quote (2002 nil)))
  '(vhdl-stutter-mode t)
  '(visible-bell t))

 ;; (custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right

 (defun code-review-region (beg end)
   (interactive "r")
   (let* ((text (chomp (buffer-substring-no-properties beg end)))
          (line-number (line-number-at-pos))
          (file (buffer-file-name))
          (path (replace-regexp-in-string "^.*branches/" ""
                                          (replace-regexp-in-string
                                           "^.*trunk/" "" file))))
     (with-temp-buffer
       (insert text)
       (goto-char (point-min))
       (while (re-search-forward "^" nil t)
         (replace-match "| " nil nil))
       (goto-char (point-min))
       (insert (format "+---[%s:%s]\n" path line-number))
       (goto-char (point-max))
       (insert "\n+---\n")
       (kill-region (point-min) (point-max)))))


;; Helm - Emacs incremental completion and selection narrowing framework
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
(setq helm-net-prefer-curl-p t))

(setq helm-split-window-inside-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)

(setq helm-autoresize-min-height 40)
(helm-autoresize-mode 1)

(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
(setq helm-locate-fuzzy-match t)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-S-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-c h o") 'helm-occur)

(helm-mode 1)



;; Smex is a M-x enhancement for Emacs. Built on top of Ido, it provides a
;; convenient interface to your recently and most frequently used commands. And
;; to all the other commands, too.
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay when Smex
                  ; is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;------------------------------------------------------------------------------
;;   Customize keybindings
;;------------------------------------------------------------------------------
;; ISpell correction
(define-key ctl-x-map "\C-i" 'endless/ispell-word-then-abbrev)
(defun endless/ispell-word-then-abbrev (p)
  "Call `ispell-word'. Then create an abbrev for the correction made.
With prefix P, create local abbrev. Otherwise it will be global."
  (interactive "P")
  (let ((bef (downcase (or (thing-at-point 'word) ""))) aft)
    (call-interactively 'ispell-word)
    (setq aft (downcase (or
                         (thing-at-point 'word) "")))
    (unless (string= aft bef)
      (message "\"%s\" now expands to \"%s\" %sally"
               bef aft (if p "loc" "glob"))
      (define-abbrev
        (if p local-abbrev-table global-abbrev-table)
        bef aft))))

(setq save-abbrevs t)
(setq-default abbrev-mode t)

(global-set-key (kbd "C-s-<right>") 'shrink-window-horizontally)
 (global-set-key (kbd "C-s-<left>") 'enlarge-window-horizontally)
 (global-set-key (kbd "C-s-<up>") 'shrink-window)
 (global-set-key (kbd "C-s-<down>") 'enlarge-window)

(global-set-key (kbd "<f2>") 'kill-ring-save) ; copy.
(global-set-key (kbd "<f3>") 'yank) ; paste.
(define-key global-map [f4] 'call-last-kbd-macro)
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key  (kbd "<f6>")   `dumb-jump-go)
(global-set-key [(shift f6)] `dumb-jump-back)
(global-set-key '[f7]   'yas-expand)
(global-set-key '[f8] 'ace-window)
(global-set-key '[f10] 'helm-locate)
(global-set-key '[(shift) f11] 'toggle-truncate-lines)
(global-set-key '[f11]  'hippie-expand)
(global-set-key '[f12]  'dabbrev-expand)
;; Fenster rückwärts springen
          (defun other-window-backward (n)
            "Select Nth previous window."
            (interactive "p")
            (other-window (- n)))
 (global-set-key [(shift down)] 'other-window)
(global-set-key [(shift up)] 'other-window-backward)

(global-set-key "\M-d"  'kill-word)
 (global-set-key "\M-b"  'backward-word)
 (global-set-key "\M-g"  'avy-goto-line)
 (global-set-key "\M-k"  'kill-buffer)
 (global-set-key "\M-o"  'occur)
 (global-set-key [delete] 'delete-char)
 (global-set-key [kp-delete] 'delete-char)
 (define-key isearch-mode-map '[backspace] 'isearch-delete-char)

;; Redefine backspace to really mean backspace (and not delete)
;; and make delete do what we expect it to do.
 (define-key function-key-map [backspace] [8])
 (global-set-key [backspace] 'delete-backward-char)
 (global-set-key [delete] 'delete-char)

;; Examples for the mouse key family
;(global-set-key [S-mouse-1]  'kill-line )
;(global-set-key [S-mouse-2]  'kill-word)
;(global-set-key [S-mouse-3]  'bubble-line-up)
(global-set-key [mouse-2]  'mouse-yank-at-click)
(global-set-key [mouse-3] 'yank)

;;----------------------------------------------------------------------------
;;   Functions
;;----------------------------------------------------------------------------
;; helpful set globally
;;ASCII table function
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)  (switch-to-buffer "*ASCII*")  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))  (let ((i 0))
    (while (< i 254)      (setq i (+ i 1))
      (insert (format "%4d %c\n" i i))))  )

;; un-disable case conversion commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'eval-expression 'disabled nil)

(defun move-line-up ()
  "Move up the current line."
   (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control shift up)]  'move-line-up)
(global-set-key [(control shift down)]  'move-line-down)

;; Xilinx ucf-file mode
(add-to-list 'load-path "/home/hhanff/.emacs.d/site-lisp/emacs-ucf-mode")
(autoload 'ucf-mode "ucf-mode" "Xilinx UCF mode" t)
(add-to-list 'auto-mode-alist '("\\.ucf\\'" . ucf-mode))

(autoload 'yaml-mode "yaml-mode")
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("jsTestDriver\\.conf$" . yaml-mode))

;; Emacs lisp
(add-to-list 'auto-mode-alist '("Carton$" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

;; CSS
(add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))
(autoload 'turn-on-css-eldoc "css-eldoc")
(add-hook 'css-mode-hook 'turn-on-css-eldoc)

;; HTML
(add-to-list 'auto-mode-alist '("\\.html\\'" . crappy-jsp-mode))
(add-to-list 'auto-mode-alist '("\\.tag$" . html-mode))
(add-to-list 'auto-mode-alist '("\\.vm$" . html-mode))
(add-to-list 'auto-mode-alist '("\\.ejs$" . html-mode))

;; Ruby
(autoload 'rhtml-mode "rhtml-mode")
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.watchr$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))

;; SVG
(add-to-list 'auto-mode-alist '("\\.svg$" . image-mode))

;; Configuration files
(add-to-list 'auto-mode-alist '("\\.offlineimaprc$" . conf-mode))

;; Snippets
(add-to-list 'auto-mode-alist '("yasnippet/snippets" . snippet-mode))
(add-to-list 'auto-mode-alist '("\\.yasnippet$" . snippet-mode))

;; Markdown
(autoload 'markdown-mode "markdown-mode")
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

;; org-mode
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; vhdl-mode
(add-to-list 'auto-mode-alist '("\\.vhd$" . vhdl-mode))

;; Apache config
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

;; xml-mode
(add-to-list 'auto-mode-alist '("\\.xml$" . xml-mode))

;; Load verilog mode only when needed
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files in verilog mode should have their keywords colorized
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))

;; Load vhdl mode only when needed
(autoload 'vhdl-mode "vhdl-mode" "Vhdl mode" t )
;; Any files in vhdl mode should have their keywords colorized
(add-hook 'vhdl-mode-hook '(lambda () (font-lock-mode 1)))

'(source-file-menu t)
(autoload 'vhdl-mode "vhdl-mode" "VHDL Mode" t)
(setq vhdl-basic-offset 4)

;; Usage: Open any vhdl file and invoke vhdl-goto-type-def with key sequence (\C-c\C-s by default).
;; Cursor will jump to corresponding definition if there is one. Functions searches packages
;; too. If no buffer with package is open, functions asks for location of package.
;; To get back to the start of the search, press \C-x\C-x if corresponding definition has been found
;; in the same file, \C-x b RET if the search has jumped to another buffer.
(add-to-list 'load-path "/home/hhanff/.emacs.d/site-lisp/vhdl-goto-def")
(load "vhdl-goto-def.elc")
(global-set-key '[f9]  'vhdl-goto-type-def)

;; Automatically guess the offset, depending on the file opened
(require 'dtrt-indent)
(dtrt-indent-mode 1)

;; (require 'indent-guide)
;; (indent-guide-global-mode)

(require 'highlight-indentation)
(set-face-background 'highlight-indentation-face "#e3e3d3")
(set-face-background 'highlight-indentation-current-column-face "#c3b3b3")
(add-hook 'c-mode-hook 'highlight-indentation-mode)
(add-hook 'c++-mode-hook 'highlight-indentation-mode)
(add-hook 'vhdl-mode-hook 'highlight-indentation-mode)
(add-hook 'python-mode-hook 'highlight-indentation-mode)

(require 'cedet)
(require 'semantic/tag)
(require 'semantic/lex)
(require 'ede)
(global-ede-mode 1)                      ; Enable the Project management system


;; Autocomplete
; Make autocompletion work in terminal mode
(add-hook 'term-mode-hook (lambda()
                            (setq yas-dont-activate-functions t)))

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-comphist-file (expand-file-name
            "~/.emacs.d/ac-comphist.dat"))
(ac-config-default)
;; Enable completion for all file types
(require 'auto-complete)
(global-auto-complete-mode t)
(setq-default auto-complete-mode 1)
(auto-complete-mode 1)
(add-hook 'vhdl-mode-hook 'auto-complete-mode)
;; start completion when entered 4 characters
(setq ac-auto-start 4)
;;(require 'auto-complete-auctex)
;; Use C-n/C-p to select candidates
;; --------------------------------
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

(add-hook 'vhdl-mode-hook (lambda () (interactive) (auto-complete-mode)))
(global-visual-line-mode 0)

;; EDE
(global-ede-mode 1)
(ede-enable-generic-projects)
;; I uncommented lines 892-1082 in all ecb-upgrade.el, made backup files of all ecb-upgrade.elc files,
;; compiled ecb-upgrade.el and copied the new ecb-upgrade.elc file to the appropriate locations.
;; No idea what those lines did, but for me it works fine....

;;(setq inhibit-startup-message t)

;; highlight columns 78 to 80 in some modes
;; (require 'whitespace)
;; (setq whitespace-style (quote (lines-tail))
(setq whitespace-line-column 210)

(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-samee "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;; Highlight the current line of the cursor
(require 'highline)
(defun highline-mode-on () (highline-mode 1))
(global-hl-line-mode 1)
;; To customize the background color
;; See colors: Alt-x list-colors-display

;; Turn on local highlighting for Dired (C-x d)
(add-hook 'dired-after-readin-hook #'highline-mode-on)
;; Turn on local highlighting for list-buffers (C-x C-b)
(defadvice list-buffers (after highlight-line activate)
  (save-excursion
    (set-buffer "*Buffer List*")
   (highline-mode-on)))

;;Emacs Dired Human-Readable File Sizes
(setq dired-listing-switches "-alh")

;; Nuke whitespaces when writing to a file
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Guru mode disables some common keybindings and suggests the use of the
;; established Emacs alternatives instead.
(require 'guru-mode)
;; Enable globally
(guru-global-mode +1)

;; Enable Menu Bar
(menu-bar-mode t)
;; Enable Scrollbar
(scroll-bar-mode t)

;; Company is a text completion framework for Emacs. The name stands
;; for "complete anything".
(autoload 'company-mode "company" nil t)
(add-hook 'after-init-hook 'global-company-mode)

;; Highlight nested parens, brackets, braces a different color at each depth.
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Disable whitespace comparison in vc-diff
(setq vc-svn-diff-switches '("-x --ignore-eol-style" "-x -w"))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'org)

(require 'ediff)
;; don't start another frame
;; this is done by default in prelude
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; put windows side by side
(setq ediff-split-window-function (quote split-window-horizontally))
;;revert windows on exit - needs winner mode
(winner-mode)
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)


(require 'move-text)
(move-text-default-bindings)
(global-set-key [(control shift up)]  'move-text-up)
(global-set-key [(control shift down)]  'move-text-down)

(defun my_comment-line (n)
     "Comment or uncomment current line and leave point after it.
With positive prefix, apply to N lines including current one.
With negative prefix, apply to -N lines above."
     (interactive "p")
     (comment-or-uncomment-region
          (line-beginning-position)
          (goto-char (line-end-position n)))
     (forward-line 1)
     (back-to-indentation))

(require 'bind-key)
(bind-key* "C-;" 'my_comment-line)


(setq tramp-verbose 6)
(setq tramp-default-method "ssh")

(autoload 'paperless "paperless" "A major mode for filing PDFs" t)
(custom-set-variables
 '(paperless-capture-directory "/home/hhanff/Dokumente/Scans")
 '(paperless-root-directory "/home/hhanff/Dokumente"))

(require 'which-key)
(which-key-mode)

;;------------------------------------------------------------------------------
;; Themes
;;------------------------------------------------------------------------------
;; (load-theme 'zenburn f)
;; (load-theme 'afternoon t)
;; (disable-theme 'zenburn)
;; (disable-theme 'afternoon)
;; ;; Enable solarize dark theme
;; ;; (setq prelude-theme 'solarized-dark)
;; ;; (require 'color-theme-solarized)
;; (setq calendar-location-name "Bremen, DE")
;; (setq calendar-latitude 53.08)(setq calendar-latitude 53.08)
;; (setq calendar-longitude 8.80)
;; (require 'theme-changer)
;; (change-theme 'solarized-light 'solarized-dark)

;; auto insert closing bracket
(electric-pair-mode 1)
(use-package dumb-jump
  :ensure t
  :config (setq dumb-jump-selector 'ivy))

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; (global-set-key "\C-s" 'i-search)
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c k") 'counsel-ag)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

(add-hook 'markdown-mode-hook 'pandoc-mode)
;; (add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)

;; Python stuff

(defvar my-packages
  '(better-defaults
    ein ;; add the ein package (Emacs ipython notebook)
    elpy
    flycheck
    material-theme
    py-autopep8))

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      my-packages)


(elpy-enable)

;; Make pdflatex work withcv_hhanff_en.tex
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -shell-escape %S%(PDFout)")))

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(global-git-gutter-mode +1)

;; Mode for editing req files from rmtool
(add-to-list 'load-path "/home/hhanff/.emacs.d/site-lisp/")
(autoload 'req-mode "req-mode" "rmtool req-mode" t)
(add-to-list 'auto-mode-alist '("\\.req\\'" . req-mode))

;; To convert non printable text characters to german Umlaute open
;; my_convert_to_utf8.el mark everything and do M-x eval-region.
;; Next open the affected file and call the lisp function

;;; Personal.el ends here
