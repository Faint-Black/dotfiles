;;-----------------------------------------------------------------------+
;; PACKAGE CONFIGURATIONS                                                |
;;-----------------------------------------------------------------------+

;; set up package sources and use-package
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; pretty org-mode custom headline bullet points
(use-package org-superstar
    :ensure t
    :hook 
    (org-mode . org-superstar-mode)
    :config
    (setq org-superstar-headline-bullets-list '("‣" "•" "➤" "-")))

;; pretty org-mode calendar/agenda
(use-package calfw
    :ensure t
    :config
    (use-package calfw-org :ensure t))




;;-----------------------------------------------------------------------+
;; USER-SPECIFIC FILEPATHS, DONT FORGET TO CHANGE THIS!!                 |
;;-----------------------------------------------------------------------+
(setq initial-buffer-choice "~/Desktop/notes/emacs/home.org")
(setq org-agenda-files '("~/Desktop/notes/emacs/org-files/Calendar.org"))




;;-----------------------------------------------------------------------+
;; CUSTOM UNIQUE-ONLY EMACS DEFINITIONS                                  |
;;-----------------------------------------------------------------------+

(custom-set-faces
    ;; org-mode: calendar framework faces
    '(cfw:face-title ((t (:foreground "#f0dfaf" :weight bold :height 2.0 :inherit variable-pitch))))
    '(cfw:face-header ((t (:foreground "#d0bf8f" :weight bold))))
    '(cfw:face-sunday ((t :foreground "#a4cbff" :background "unspecified" :weight bold)))
    '(cfw:face-saturday ((t :foreground "#a4cbff" :background "unspecified" :weight bold)))
    '(cfw:face-holiday ((t :foreground "#8c5353" :background "unspecified" :weight bold)))
    '(cfw:face-grid ((t :foreground "DarkGrey")))
    '(cfw:face-default-content ((t :foreground "#bfebbf")))
    '(cfw:face-periods ((t :foreground "cyan")))
    '(cfw:face-day-title ((t :background "unspecified")))
    '(cfw:face-default-day ((t :weight bold :inherit cfw:face-day-title)))
    '(cfw:face-annotation ((t :foreground "RosyBrown" :inherit cfw:face-day-title)))
    '(cfw:face-disable ((t :foreground "DarkGray" :inherit cfw:face-day-title)))
    '(cfw:face-today-title ((t :background "#dd3333" :weight bold)))
    '(cfw:face-today ((t :background: "#663333" :weight bold)))
    '(cfw:face-select ((t :background "#2f2f2f")))
    '(cfw:face-toolbar ((t :background "unspecified")))
    '(cfw:face-toolbar-button-off ((t :foreground "gray")))
    '(cfw:face-toolbar-button-on ((t :foreground "white" :weight bold :underline t)))
    ;; org-mode: faces
    '(org-code ((t (:foreground "#faf678"))))
    '(org-level-1 ((t (:foreground "#df8735" :weight bold :height 1.0))))
    '(org-level-2 ((t (:foreground "#9e7ece" :weight bold :height 1.0))))
    '(org-level-3 ((t (:foreground "#47d055" :weight bold :height 1.0))))
    '(org-level-4 ((t (:foreground "#87f095" :weight bold :height 1.0))))
    '(org-level-5 ((t (:foreground "#f0ce87" :weight bold :height 1.0))))
    '(org-level-6 ((t (:foreground "#d1db5e" :weight bold :height 1.0)))))




;;-----------------------------------------------------------------------+
;; GENERAL EMACS CONFIGURATIONS                                          |
;;-----------------------------------------------------------------------+

;; base theme
(load-theme 'wombat t)

;; GUI application settings
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)




;;-----------------------------------------------------------------------+
;; ORG-MODE CONFIGURATIONS                                               |
;;-----------------------------------------------------------------------+

;; org agenda configurations
(global-set-key (kbd "C-c a") 'cfw:open-org-calendar)

;; boiler-plate stuff (i forgot what this does)
(add-hook 'text-mode-hook 'visual-line-mode)

;; text is indented according to it's header depth
(setq org-startup-indented t)

;; start headers as unfolded by default
(setq org-startup-folded 'showall)

;; inline image configurations
(add-hook 'org-mode-hook 'org-display-inline-images)
(setq org-image-actual-width nil)

;; ensure proper org-mode link behaviour
(setq org-link-frame-setup
      '((file . find-file)            ; Open file links in the current window
        (dired . dired)               ; Open dired links in a dired buffer
        (wl . wl)                     ; Open wl (Wanderlust) links in a wl buffer
        (gnus . gnus)                 ; Open gnus links in a gnus buffer
        (url . browse-url)))          ; Open URL links in the default web browser

;; do not prompt for confirmation before running org-mode src code blocks
(setq org-confirm-babel-evaluate nil)

