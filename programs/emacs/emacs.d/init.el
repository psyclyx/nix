(setq comp-deferred-compilation nil)

(package-initialize)

(push (expand-file-name "lisp" user-emacs-directory) load-path)
(push (expand-file-name "modules" user-emacs-directory) load-path)

(require 'cherub-vars)

(load (expand-file-name "init.el" cherub-user-dir))
