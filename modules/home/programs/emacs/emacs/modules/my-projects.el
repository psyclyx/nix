(use-package projectile
  :config
  (projectile-mode +1))

(use-package magit
  :commands magit-status
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(provide 'my-projects)
