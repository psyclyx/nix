;;;-*- lexical-binding: t -*-

(eval-and-compile
  (defvar no-littering-etc-directory (expand-file-name "etc/" "~/.local/state/emacs"))
  (defvar no-littering-var-directory (expand-file-name "var/"  "~/.cache/emacs"))
  (require 'no-littering))

(require 'org)

(defun my--file-last-changed (filename)
  (file-attribute-status-change-time (file-attributes filename 'string)))

(let* ((config (expand-file-name "config.org" user-emacs-directory))
       (cached-name (expand-file-name "~/.cache/emacs/config"))
       (cached-el (concat cached-name ".el"))
       (cached-elc (concat cached-name ".elc"))
       (older (or (not (file-exists-p cached-el))
                  (not (file-exists-p cached-elc))
                  (time-less-p (my--file-last-changed cached-el)
                               (my--file-last-changed config)))))
  (when older
    (let ((org-confirm-babel-evaluate nil))
      (delete-file cached-el)
      (delete-file cached-elc)
      (org-babel-tangle-file config cached-el)
      ;; (byte-compile-file cached-el)
      ))
  (load cached-name))
