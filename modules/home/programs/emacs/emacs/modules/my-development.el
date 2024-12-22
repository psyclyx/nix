(use-package eglot
  :hook ((python-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (web-mode . eglot-ensure))
  :config
  (setq eglot-events-buffer-size 0
        eglot-sync-connect nil
        eglot-connect-timeout 10
        eglot-autoshutdown t)

  (setq completion-category-defaults nil))

(use-package flycheck
  :init
  (global-flycheck-mode)
  :config
  (setq flycheck-display-errors-delay 0.3))

(use-package cider
  :defer t
  :init
  (setq cider-repl-display-help-banner nil)
  :config
  (setq cider-show-error-buffer t
        cider-auto-select-error-buffer t
        cider-repl-history-file "~/.emacs.d/cider-history"
        cider-repl-wrap-history t
        cider-repl-history-size 1000
        cider-repl-use-clojure-font-lock t)

  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode))

(use-package elisp-mode
  :hook ((emacs-lisp-mode . eldoc-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . show-paren-mode))
  :config
  (setq lisp-indent-function 'lisp-indent-function))

(use-package nix-mode
  :mode "\\.nix\\'")

(provide 'my-development)
