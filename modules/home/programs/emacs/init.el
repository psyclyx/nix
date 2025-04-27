;;;-*- lexical-binding: t -*-

(eval-and-compile
  (defvar no-littering-etc-directory (expand-file-name "etc/" "~/.local/state/emacs"))
  (defvar no-littering-var-directory (expand-file-name "var/"  "~/.cache/emacs"))
  (require 'no-littering))

(require 'org)

(defun my--file-last-changed (filename)
  (file-attribute-status-change-time (file-attributes filename 'string)))

(let* ((config (expand-file-name "config.org" user-emacs-directory))
       (cached (expand-file-name "~/.cache/emacs/config.el"))
       (older (or (not (file-exists-p cached))
		  (time-less-p (my--file-last-changed cached)
                               (my--file-last-changed config)))))
  (when older
    (let ((org-confirm-babel-evaluate nil))
      (delete-file cached)
      (org-babel-tangle-file config cached)))
  (load-file cached))
