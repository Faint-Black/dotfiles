;;-----------------------------------------------------------------------+
;; UTILITIES                                                             |
;;-----------------------------------------------------------------------+

;; Check if emacs was invoked on a terminal with filepath arguments
(defconst has-command-line-args (> (length command-line-args) 1))

;; Keybind setter helper function
(defun leader-keybind(KEY COMMAND)
  "Binds <C-c KEY> to COMMAND"
  (global-set-key (kbd (concat "C-c " KEY)) COMMAND))

;; Keybind setter helper function
(defun ctrl-keybind(KEY COMMAND)
  "Binds <C-KEY> to COMMAND"
  (global-set-key (kbd (concat "C-" KEY)) COMMAND))

;; Keybind setter helper function
(defun meta-keybind(KEY COMMAND)
  "Binds <M-KEY> to COMMAND"
  (global-set-key (kbd (concat "M-" KEY)) COMMAND))

;; Keybind setter
(defun set-custom-keybind(PREFIX KEY COMMAND)
  "Prefix may be \"CONTROL\" or \"META\", binds <PRE-KEY> to COMMAND."
  (cond
   ((string= PREFIX "LEADER") (leader-keybind KEY COMMAND))
   ((string= PREFIX "CONTROL") (ctrl-keybind KEY COMMAND))
   ((string= PREFIX "META") (meta-keybind KEY COMMAND))
   (t (error "Unknown prefix"))))





;;-----------------------------------------------------------------------+
;; USER-SPECIFIC FILEPATHS                                               |
;;-----------------------------------------------------------------------+

;; Each function that uses these values first checks if they even exist
;; in the first place, so don't worry about not having these
;; files on your machine. My code is built to handle the exceptions by
;; simply doing nothing if the files do not exist.
(defconst home-file "~/Desktop/notes/emacs/home.org")
(defconst agenda-file "~/Desktop/notes/emacs/org-files/Calendar.org")
(defconst cookbook-file "~/Desktop/notes/emacs/org-files/Recipes.org")
(defconst feeds-file "~/Desktop/notes/emacs/org-files/Feed.org")

(if (not has-command-line-args)
    (progn
      (if (file-exists-p home-file)
          (setq initial-buffer-choice home-file))
      (if (file-exists-p agenda-file)
          (setq org-agenda-files (list agenda-file)))))





;;-----------------------------------------------------------------------+
;; PACKAGE CONFIGURATIONS                                                |
;;-----------------------------------------------------------------------+

;; Set up package sources
(setq package-archives (list (cons "melpa" "https://melpa.org/packages/")
                             (cons "elpa" "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

;; Manually install use-package
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t) ; ":ensure t" as global default

;; Magit!
(use-package magit)

;; Docker integration
(use-package docker)

;; Better terminal emulator
(use-package vterm)

;; Inherit .bashrc PATH variable
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; Dired file icons
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; Matching parentheses coloring
(use-package rainbow-delimiters
  :hook
  (lisp-mode . rainbow-delimiters-mode)
  (emacs-lisp-mode . rainbow-delimiters-mode)
  :custom-face
  (rainbow-delimiters-depth-1-face ((t :foreground "#FFFFFF" :weight bold)))
  (rainbow-delimiters-depth-2-face ((t :foreground "#80FFFF")))
  (rainbow-delimiters-depth-3-face ((t :foreground "#FF80FF")))
  (rainbow-delimiters-depth-4-face ((t :foreground "#FFFF00")))
  (rainbow-delimiters-depth-5-face ((t :foreground "#8080FF")))
  (rainbow-delimiters-depth-6-face ((t :foreground "#FF8080")))
  (rainbow-delimiters-depth-7-face ((t :foreground "#80FF80")))
  (rainbow-delimiters-depth-8-face ((t :foreground "#808080")))
  (rainbow-delimiters-depth-9-face ((t :foreground "#FF00FF"))))

;; OpenGL shader mode
(use-package glsl-mode)

;; CMake mode
(use-package cmake-mode)

;; Ziglang mode
(use-package zig-mode)

;; Julia mode
(use-package julia-mode)

;; Julia REPL
(use-package julia-repl
  :hook
  (julia-mode . julia-repl-mode)
  :config
  (julia-repl-set-terminal-backend 'vterm))

;; Haskell mode
(use-package haskell-mode
  :custom
  (haskell-indentation-layout-offset 4)
  (haskell-indentation-left-offset 4)
  (haskell-indentation-starter-offset 4)
  (haskell-indentation-where-post-offset 4)
  (haskell-indentation-where-pre-offset 4))

;; Clojure mode
(use-package clojure-mode)

;; Scheme backend
(use-package geiser)

;; Guile mode
(use-package geiser-guile
  :after geiser)

;; Clojure REPL and compiler
(use-package cider
  :hook
  (clojure-mode . cider-mode))

;; Lisp mode
(use-package slime
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (setq slime-contribs '(slime-fancy)))

;; Lisp mode auto-completion
(use-package slime-company
  :after (slime company)
  :config
  (setq company-backends '(company-slime)))

;; Automatic clang-format for C/C++ buffers
(use-package clang-format
  :hook
  (c-mode . clang-format-on-save-mode)
  (c++-mode . clang-format-on-save-mode))

;; Language Service Providers
(use-package lsp-mode
  :commands lsp
  :hook
  (zig-mode . lsp-mode)   ; zls
  (c-mode . lsp-mode)     ; clangd
  (c++-mode . lsp-mode)   ; clangd
  :custom
  (lsp-enable-symbol-highlighting t))

;; LSP graphic information
(use-package lsp-ui
  :hook
  (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-enable t))

;; LSP auto-completion and snippets
(use-package company
  :init
  (global-company-mode)
  :hook
  (lisp-mode . company-mode)
  (lsp-mode . company-mode)
  (LaTeX-mode . company-mode)
  ((geiser-mode geiser-repl-mode) . company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 1)
  :config
  (delq 'company-dabbrev company-backends)
  (add-to-list 'company-backends 'company-capf))

;; LSP snippets
(use-package yasnippet
  :hook
  (prog-mode . yas-minor-mode))

;; Org-mode cookbook recipes
(use-package org-chef
  :config
  (setq org-capture-templates
        (if (file-exists-p cookbook-file)
            (list
             (list "c" "Cookbook"
                   'entry
                   (list 'file cookbook-file)
                   "%(org-chef-get-recipe-from-url)"
                   ':empty-lines 1)
             (list "z" "Protocol Cookbook"
                   'entry
                   (list 'file cookbook-file)
                   "%(org-chef-get-recipe-string-from-url \"%:link\")"
                   ':empty-lines 1)
             (list "m" "Manual Cookbook"
                   'entry
                   (list 'file cookbook-file)
                   (concat
                    "* %^{Recipe title: }\n"
                    "  :PROPERTIES:\n"
                    "  :source-url:\n"
                    "  :servings:\n"
                    "  :prep-time:\n"
                    "  :cook-time:\n"
                    "  :ready-in:\n"
                    "  :END:\n"
                    "** Ingredients\n"
                    "   %?\n"
                    "** Directions\n\n")))
          nil)))

;; Pretty org-mode custom headline bullet points
(use-package org-superstar
  :hook
  (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list
   (list
    (string 8227)    ; (U+2023) Triangular Bullet
    (string 8857)    ; (U+2299) Circled Dot Operator
    (string 10148)   ; (U+27a4) Black Rightwards Arrowhead
    (string 8226)    ; (U+2022) Bullet
    (string 9702)    ; (U+25e6) White Bullet
    (string 8859)))) ; (U+229b) Circled Asterisk Operator

;; Pretty org-mode calendar/agenda
(use-package calfw)
(use-package calfw-org
  :requires (calfw)
  :custom-face
  (cfw:face-annotation ((t :foreground "RosyBrown" :inherit cfw:face-day-title)))
  (cfw:face-day-title ((t :background "unspecified")))
  (cfw:face-default-content ((t :foreground "#bfebbf")))
  (cfw:face-default-day ((t :weight bold :inherit cfw:face-day-title)))
  (cfw:face-disable ((t :foreground "DarkGray" :inherit cfw:face-day-title)))
  (cfw:face-grid ((t :foreground "DarkGrey")))
  (cfw:face-header ((t (:foreground "#d0bf8f" :weight bold))))
  (cfw:face-holiday ((t :foreground "#8c5353" :background "unspecified" :weight bold)))
  (cfw:face-periods ((t :foreground "cyan")))
  (cfw:face-saturday ((t :foreground "#a4cbff" :background "unspecified" :weight bold)))
  (cfw:face-select ((t :background "#2f2f2f")))
  (cfw:face-sunday ((t :foreground "#a4cbff" :background "unspecified" :weight bold)))
  (cfw:face-title ((t (:foreground "#f0dfaf" :weight bold :height 2.0 :inherit variable-pitch))))
  (cfw:face-today ((t :background: "#663333" :weight bold)))
  (cfw:face-today-title ((t :background "#dd3333" :weight bold)))
  (cfw:face-toolbar ((t :background "unspecified")))
  (cfw:face-toolbar-button-off ((t :foreground "gray")))
  (cfw:face-toolbar-button-on ((t :foreground "white" :weight bold :underline t))))

;; LaTeX editing
(use-package auctex
  :hook
  (LaTeX-mode . flyspell-mode)
  (LaTeX-mode . TeX-source-correlate-mode)
  :config
  (setq TeX-electric-sub-and-superscript nil)
  (setq tex-fontify-script nil)
  (setq font-latex-fontify-script nil)
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  (setq TeX-brace-indent-level 4)
  (setq LaTeX-indent-level 4)
  (setq LaTeX-item-indent 0)
  (setq tex-indent-basic 4)
  (setq tex-indent-item 4)
  :custom-face
  (font-latex-sectioning-1-face ((t :foreground "#40d080" :weight bold :height 1.5 :inherit nil)))
  (font-latex-sectioning-2-face ((t :foreground "#64d860" :weight bold :height 1.4 :inherit nil)))
  (font-latex-sectioning-3-face ((t :foreground "#88e040" :weight bold :height 1.3 :inherit nil)))
  (font-latex-sectioning-4-face ((t :foreground "#ace820" :weight bold :height 1.2 :inherit nil)))
  (font-latex-sectioning-5-face ((t :foreground "#d0f000" :weight bold :height 1.1 :inherit nil))))

;; LaTeX auto-completion
(use-package company-auctex
  :requires (company) ; me too...
  :config
  (company-auctex-init))

;; PDF tools for viewing documents
(use-package pdf-tools
  :config
  (pdf-tools-install)
  :custom
  (pdf-view-continuous nil))

;; Live pdf preview pane
;; (not the actual reader, just a package that automates the pdf viewing process)
(use-package latex-preview-pane
  :config
  (define-key latex-preview-pane-mode-map (kbd "M-p") nil)
  :custom
  (latex-preview-pane-multifile-mode 'auctex)
  (shell-escape-mode "-shell-escape")
  (pdf-latex-command "pdflatex"))

;; Make auctex and latexmk work with eachother, necessary for synctex
(use-package auctex-latexmk
  :config
  (auctex-latexmk-setup))

;; Move selected region up or down
(use-package drag-stuff
  :config
  (drag-stuff-global-mode 1))

;; ANSI terminal colors for compilation mode buffers
(use-package ansi-color
  :hook
  (compilation-filter . ansi-color-compilation-filter))

;; Only show current major mode in modeline
(use-package minions
  :config
  (minions-mode 1))

;; RSS feed reader
(use-package elfeed)

;; Elfeed org-mode init file
(use-package elfeed-org
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files
        (if (file-exists-p feeds-file)
            (list feeds-file)
          nil)))

;; Elfeed customization addons
(use-package elfeed-goodies
  :config
  (elfeed-goodies/setup))

;; Ledger accounting and budgeting
(use-package ledger-mode)

;; Fun zone
(use-package nyan-mode)
(use-package fireplace)
(use-package zone-sl)
(use-package pacmacs)
(use-package blackjack)
(use-package 2048-game)





;;-----------------------------------------------------------------------+
;; CORE EMACS CONFIGURATIONS                                             |
;;-----------------------------------------------------------------------+

;; Base theme
(load-theme 'wombat t)

;; GUI application settings
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Mode line settings
(setq-default mode-line-compact t)
(display-time)
(display-battery-mode)

;; Tabs to spaces and indentation settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default sh-indentation 2)

;; Reserve highlighted trailing whitespaces for prog-mode buffers
(setq show-trailing-whitespace nil)

;; Disable automatic generation of junk files
(setq-default make-backup-files nil) ;; Disable backup files    (foo.org~)
(setq-default auto-save-default nil) ;; Disable auto-save files (#foo.org#)
(setq-default create-lockfiles nil)  ;; Disable lock files      (.#foo.org)

;; Enable disabled commands
(setq-default disabled-command-function nil)

;; Compilation mode settings
(setq-default compilation-ask-about-save nil)         ;; auto-save when compiling
(setq-default compilation-auto-jump-to-first-error t) ;; jump to first error
(setq-default compile-command "make")                 ;; default compile prompt
(setq-default use-file-dialog nil)                    ;; disable file selector on error

;; Elisp evaluation settings
(setq-default eval-expression-print-length nil) ;; remove eval print length limit
(setq-default eval-expression-print-level nil)  ;; remove eval print level limit

;; Grep mode settings
(setq-default grep-command "grep -nHrZ --color=auto ")

;; Dired backend mode settings
(setq-default dired-listing-switches "-alh --group-directories-first")

;; "browse-url" decided to stop working...
(setq-default browse-url-browser-function 'browse-url-xdg-open)

;; SSH access variables
(setq tramp-remote-path
      (append tramp-remote-path
              (list
               ;; Magic thing that makes other thing work
               'tramp-own-remote-path
               ;; GuixSD PATH
               "/run/current-system/profile/bin")))





;;-----------------------------------------------------------------------+
;; CUSTOM HOOKS                                                          |
;;-----------------------------------------------------------------------+

;; On init
(add-hook
 'emacs-startup-hook
 (lambda()
   (if (and (file-exists-p agenda-file) (not has-command-line-args))
       (org-agenda-list))))

;; On programming buffers
(add-hook
 'prog-mode-hook
 (lambda()
   (setq-local show-trailing-whitespace t)))

;; On LaTeX buffers
(add-hook
 'LaTeX-mode-hook
 (lambda()
   (if (y-or-n-p "Activate LaTeX preview pane on this buffer?")
       (latex-preview-pane-mode))
   (keymap-local-set "M-p"
                     (lambda()
                       (interactive)
                       (latex-preview-pane-update)
                       (call-process-shell-command "latexmk -gg -silent")
                       (latex-preview-pane-update)))))

;; On text-editing buffers
(add-hook
 'text-mode-hook
 (lambda()
   (visual-line-mode)))

;; On assembly buffers
(add-hook
 'asm-mode-hook
 (lambda()
   (setq-local indent-line-function #'ignore)
   (keymap-local-set ";" 'self-insert-command)
   (keymap-local-set "TAB"
                     (lambda()
                       (interactive)
                       (insert "    "))))) ; holy hack!





;;-----------------------------------------------------------------------+
;; CUSTOM KEYBINDS                                                       |
;;-----------------------------------------------------------------------+

;; Open terminal emulator window
(set-custom-keybind "LEADER" "t" #'vterm)
;; Open compilation mode
(set-custom-keybind "LEADER" "c" #'compile)
;; Open org agenda calendar
(set-custom-keybind "LEADER" "a c" #'cfw:open-org-calendar)
;; Open org agenda TODO entries
(set-custom-keybind "LEADER" "a t" #'org-todo-list)
;; (LSP) open definition of hovered identifier
(set-custom-keybind "LEADER" "d" #'lsp-goto-type-definition)
;; (LSP) show buffer errors with diagnostics
(set-custom-keybind "LEADER" "e" #'flymake-show-buffer-diagnostics)
;; Drag selection up
(set-custom-keybind "META" "p" #'drag-stuff-up)
;; Drag selection down
(set-custom-keybind "META" "n" #'drag-stuff-down)





;;-----------------------------------------------------------------------+
;; ORG-MODE CONFIGURATIONS                                               |
;;-----------------------------------------------------------------------+

;; Text is indented according to it's header depth
(setq org-startup-indented t)

;; Start headers as unfolded by default
(setq org-startup-folded 'showall)

;; Attempt to find image width in previous "ATTR"
(setq org-image-actual-width nil)

;; Ensure proper org-mode link behaviour
(setq org-link-frame-setup
      '((file . find-file)   ;; Open file links in the current window
        (dired . dired)      ;; Open dired links in a dired buffer
        (wl . wl)            ;; Open wl (Wanderlust) links in a wl buffer
        (gnus . gnus)        ;; Open gnus links in a gnus buffer
        (url . browse-url))) ;; Open URL links in the default web browser

;; Do not prompt for confirmation before running org-mode code blocks
(setq org-confirm-babel-evaluate nil)

;; Prevent buggy org-mode src block automatic indentation
(setq org-edit-src-content-indentation 0)

;; Org agenda configurations
(setq org-agenda-span 30)
(setq org-agenda-format-date "%d %B %Y")





;;-----------------------------------------------------------------------+
;; ANNOYING AUTO-GENERATED CODE BY CUSTOM-SET, CONTAIN IT HERE!          |
;;-----------------------------------------------------------------------+

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-block ((t (:background "#181818"))))
 '(org-block-begin-line ((t (:foreground "#505050" :background "#303030"))))
 '(org-block-end-line ((t (:foreground "#505050" :background "#303030"))))
 '(org-code ((t (:foreground "#faf678"))))
 '(org-level-1 ((t (:foreground "#df8735" :weight bold :height 1.0))))
 '(org-level-2 ((t (:foreground "#9e7ece" :weight bold :height 1.0))))
 '(org-level-3 ((t (:foreground "#47d055" :weight bold :height 1.0))))
 '(org-level-4 ((t (:foreground "#87f095" :weight bold :height 1.0))))
 '(org-level-5 ((t (:foreground "#f0ce87" :weight bold :height 1.0))))
 '(org-level-6 ((t (:foreground "#d1db5e" :weight bold :height 1.0))))
 '(org-meta-line ((t (:foreground "#808080" :background "#303030")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(package-selected-packages
   '(org julia-repl julia-mode cmake-mode glsl-mode ledger-mode 2048-game elfeed-goodies geiser-guile geiser org-chef zig-mode org-superstar calfw-org calfw))
 '(safe-local-variable-values
   '((org-latex-default-figure-position . "H")
     (org-latex-src-block-backend . listings)
     (org-html-style-default)
     (org-html-validation-link)
     (org-html-indent)
     (org-confirm-babel-evaluate))))
