;;----------------------------------------------------------------------------;;
;; Simplified Emacs init file for pure TTY editing.                           ;;
;;----------------------------------------------------------------------------;;
(load-theme 'wombat t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(display-time)

(setq-default inhibit-startup-screen t)
(setq-default mode-line-compact t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default sh-indentation 2)
(setq-default show-trailing-whitespace t)
(setq-default make-backup-files nil)
(setq-default auto-save-default nil)
(setq-default create-lockfiles nil)
(setq-default disabled-command-function nil)

(with-eval-after-load 'org
  (progn
    (set-face-attribute 'org-level-1 nil :foreground "Orange" :weight 'bold)
    (set-face-attribute 'org-level-2 nil :foreground "Green" :weight 'bold)
    (set-face-attribute 'org-level-3 nil :foreground "Yellow" :weight 'bold)
    (set-face-attribute 'org-level-4 nil :foreground "Blue" :weight 'bold)))
