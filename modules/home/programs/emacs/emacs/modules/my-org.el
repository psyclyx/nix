(use-package org
  :config
  (setq org-directory "~/Sync/org"
        org-agenda-files '("~/Sync/org/agenda.org")
        org-log-done 'time))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-roam
  :config
  (setq org-roam-directory "~/Sync/org/roam")
  (org-roam-db-autosync-mode))

(provide 'my-org)
'';
