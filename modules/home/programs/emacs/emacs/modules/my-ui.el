(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq inhibit-startup-message t)

;; Font settings
(set-face-attribute 'default nil :font "NotoMono Nerd Font" :height 120)

;; Theme setup
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification
  (doom-themes-org-config))

;; Dashboard setup
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-items '((recents . 5)
                          (projects . 5)
                          (agenda . 5))
        dashboard-set-heading-icons t
        dashboard-set-file-icons t))

;; All the Icons
(use-package all-the-icons-nerd-fonts
  :after all-the-icons
  :if (display-graphic-p)
  :config (all-the-icons-nerd-fonts-prefer))

;; Better delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(provide 'my-ui)
