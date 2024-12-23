;; Completion framework configuration
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-count 20))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-esm-update-handlers . vertico-directory-tidy))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (basic partial-completion))))))

(use-package consult
  :after vertico
  :config
  (setq consult-preview-key "M-.")
  (setq consult-project-root-function #'projectile-project-root))

(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-prefix-prefix "◉")
  (setq which-key-sort-order 'which-key-key-order-alpha))

(use-package savehist
  :init
  (savehist-mode))

(provide 'my-completion)
