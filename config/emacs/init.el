(if (version< emacs-version "26.3")
    (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(setq visible-bell t)  ;; visual bell (no beeps)

;; Package-initialization preamble, adding melpa and melpa-stable.
(require 'package)
(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
        ("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org"          . "https://orgmode.org/elpa/")))
(package-initialize)


;; Ensure use-package is present. From here on out, all packages are
;; loaded with use-package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Allow navigation between use-package stanzas with imenu.
;; This has to be set before loading use-package.
(defvar use-package-enable-imenu-support t)

(require 'use-package)

(setq
 use-package-always-ensure t
 use-package-verbose t
 custom-safe-themes t)

;; Fullscreen by default, as early as possible.
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;; UTF-8 everywhere, please.
(prefer-coding-system 'utf-8)

;; Iosevka is my font of choice, but don't freak out if it's present.
;; (ignore-errors (set-frame-font "Iosevka-13"))
(set-frame-font "Liga Inconsolata LGC NF")

(use-package gnu-elpa-keyring-update
  :ensure t)

; (use-package undo-tree
; :ensure t
; )

;; load evil
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode 1)

  ;; example how to map a command in normal mode (called 'normal state' in evil)
  (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (evil undo-tree use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
