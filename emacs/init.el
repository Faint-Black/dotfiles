;;------------------------------------------------------------------------
;; PACKAGE CONFIGURATIONS
;;------------------------------------------------------------------------

;; set up packaging enviroment
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; evil-mode boilerplate
(setq evil-want-keybinding nil)
(unless (package-installed-p 'evil)
    (package-refresh-contents)
    (package-install 'evil))
(unless (package-installed-p 'evil-collection)
    (package-refresh-contents)
    (package-install 'evil-collection))
(require 'evil)
(evil-mode 1)
(require 'evil-collection)
(evil-collection-init)
(custom-set-variables
    '(package-selected-packages '(evil cmake-mode)))

;; pretty org-mode custom bullet points
(use-package org-superstar
    :ensure t
    :hook 
    (org-mode . org-superstar-mode)
    :config
    (setq org-superstar-headline-bullets-list '("‣" "•" "➤" "-" "'")))



;;------------------------------------------------------------------------
;; EMACS CONFIGURATIONS
;;------------------------------------------------------------------------

;; boiler-plate stuff
(add-hook 'text-mode-hook 'visual-line-mode)

;; set default buffer
(setq initial-buffer-choice "~/Desktop/notes/emacs/home.org")

;; window size
(setq initial-frame-alist '((width . 120)    ; Width in characters
                             (height . 50))) ; Height in lines

;; base theme
(load-theme 'wombat t)

;; custom headers
(custom-set-faces
 '(org-code ((t (:foreground "#faf678"))))
 '(org-level-1 ((t (:foreground "#df8735" :weight bold :height 1.6))))
 '(org-level-2 ((t (:foreground "#ae8eee" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#67f075" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#e5c732" :height 1.05))))
 '(org-level-5 ((t (:foreground "#c26736" :height 1.0)))))

;; automatically hide org-mode faces
(setq org-hide-emphasis-markers t)

;; disable/enable/customize org-mode faces here 
(setq org-emphasis-alist
      '(("*" bold)
        ("/" italic)
        ("_" underline)
        ("=" org-verbatim)
        ("~" org-code)
        ("+" (:strike-through t))
        ("-" (:strike-through t))
        ("+" (:strike-through t))
        ("_" (:strike-through t))
        ("~" (:strike-through t))))

;; text is indented according to it's header depth
(setq org-startup-indented t)

;; start headers as unfolded by default
(setq org-startup-folded 'showall)

;; inline image configurations
(add-hook 'org-mode-hook 'org-display-inline-images)
(setq org-image-actual-width nil)

;; ensure proper org-mode link behaviours
(setq org-link-frame-setup
      '((file . find-file)           ; Open file links in the current window
        (dired . dired)               ; Open dired links in a dired buffer
        (wl . wl)                     ; Open wl (Wanderlust) links in a wl buffer
        (gnus . gnus)                 ; Open gnus links in a gnus buffer
        (url . browse-url)))          ; Open URL links in the default web browser

;; bind RETURN to open links in vim mode
(evil-define-key 'normal 'global
  (kbd "RET") 'org-open-at-point)



