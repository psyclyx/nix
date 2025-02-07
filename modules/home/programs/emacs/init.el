;;;-*- lexical-binding: t -*-
(eval-and-compile ; Ensure values don't differ at compile time.
  (setq no-littering-etc-directory
        (expand-file-name "etc/" "~/.local/state/emacs"))
  (setq no-littering-var-directory
        (expand-file-name "var/"  "~/.cache/emacs"))
  (require 'no-littering))



(require 'org)
(org-babel-tangle-file (expand-file-name "config.org" user-emacs-directory) "~/.cache/emacs/config.el")
(load-file "~/.cache/emacs/config.el")
