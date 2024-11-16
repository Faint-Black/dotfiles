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
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(evil cmake-mode)))

;; pretty org-mode custom bullet points
(use-package org-superstar
    :ensure t
    :hook 
    (org-mode . org-superstar-mode)
    :config
    (setq org-superstar-headline-bullets-list '("‣" "•" "➤" "-")))



;;------------------------------------------------------------------------
;; EMACS CONFIGURATIONS
;;------------------------------------------------------------------------

;; set user-specific path configurations (CHANGE THIS FOR YOUR COMPUTER!!)
(setq initial-buffer-choice "~/Desktop/notes/emacs/home.org")

;; org agenda configurations
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-window-setup 'only-window)
(setq org-agenda-span 1)
(setq org-agenda-start-day "-3d")
(setq org-agenda-skip-timestamp-if-done nil)
(setq org-agenda-skip-deadline-if-done nil)
(setq org-agenda-skip-scheduled-if-done nil)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
(setq org-agenda-skip-timestamp-if-deadline-is-shown t)
(setq org-log-into-drawer t)

;; boiler-plate stuff
(add-hook 'text-mode-hook 'visual-line-mode)

;; window size
(setq initial-frame-alist '((width . 120)    ; Width in characters
                            (height . 50)))  ; Height in lines

;; base theme
(load-theme 'wombat t)

;; custom headers and faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-code ((t (:foreground "#faf678"))))
 '(org-level-1 ((t (:foreground "#df8735" :weight bold :height 1.4))))
 '(org-level-2 ((t (:foreground "#9e7ece" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#47d055" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#87f095" :height 1.05))))
 '(org-level-5 ((t (:foreground "#f0ce87" :height 1.0))))
 '(org-level-6 ((t (:foreground "#d1db5e" :height 1.0)))))

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

;; ensure proper org-mode link behaviour
(setq org-link-frame-setup
      '((file . find-file)            ; Open file links in the current window
        (dired . dired)               ; Open dired links in a dired buffer
        (wl . wl)                     ; Open wl (Wanderlust) links in a wl buffer
        (gnus . gnus)                 ; Open gnus links in a gnus buffer
        (url . browse-url)))          ; Open URL links in the default web browser

;; do not prompt confirmation before running code blocks
(setq org-confirm-babel-evaluate nil)

;; bind RETURN to open links in evil mode
(evil-define-key 'normal 'global
  (kbd "RET") 'org-open-at-point)

