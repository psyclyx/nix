;; General keybindings configuration
(use-package general
  :config
  (general-evil-setup)

  (general-create-definer my-leader-def
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  (my-leader-def
   :keymaps 'override
   :prefix "SPC"

   ;; Top-level commands
   "." '(find-file :which-key "find file")
   "," '(consult-buffer :which-key "switch buffer")
   "/" '(consult-ripgrep :which-key "search project")
   ";" '(eval-expression :which-key "eval expression")
   ":" '(execute-extended-command :which-key "M-x")

   ;; Buffer commands
   "b" '(:ignore t :which-key "buffer")
   "bb" '(consult-buffer :which-key "switch buffer")
   "bd" '(kill-current-buffer :which-key "kill buffer")
   "bn" '(next-buffer :which-key "next buffer")
   "bp" '(previous-buffer :which-key "previous buffer")
   "br" '(revert-buffer :which-key "reload buffer")

   ;; File commands
   "f" '(:ignore t :which-key "file")
   "ff" '(find-file :which-key "find file")
   "fs" '(save-buffer :which-key "save file")
   "fS" '(write-file :which-key "save as")
   "fr" '(consult-recent-file :which-key "recent files")

   ;; Project commands
   "p" '(:ignore t :which-key "project")
   "pf" '(projectile-find-file :which-key "find file in project")
   "pp" '(projectile-switch-project :which-key "switch project")
   "pb" '(projectile-switch-to-buffer :which-key "switch project buffer")
   "pk" '(projectile-kill-buffers :which-key "kill project buffers")

   ;; Search commands
   "s" '(:ignore t :which-key "search")
   "ss" '(consult-line :which-key "search in buffer")
   "sp" '(consult-ripgrep :which-key "search in project")
   "si" '(imenu :which-key "jump to symbol")

   ;; Git commands
   "g" '(:ignore t :which-key "git")
   "gg" '(magit-status :which-key "magit status")
   "gb" '(magit-blame :which-key "git blame")
   "gl" '(magit-log-buffer-file :which-key "git log (current file)")

   ;; Org commands
   "o" '(:ignore t :which-key "org")
   "oa" '(org-agenda :which-key "agenda")
   "oc" '(org-capture :which-key "capture")
   "ol" '(org-store-link :which-key "store link")

   ;; Toggle commands
   "t" '(:ignore t :which-key "toggle")
   "tt" '(load-theme :which-key "choose theme")
   "tl" '(display-line-numbers-mode :which-key "line numbers")
   "tw" '(whitespace-mode :which-key "whitespace")

   ;; Window commands
   "w" '(:ignore t :which-key "window")
   "wh" '(evil-window-left :which-key "window left")
   "wj" '(evil-window-down :which-key "window down")
   "wk" '(evil-window-up :which-key "window up")
   "wl" '(evil-window-right :which-key "window right")
   "ws" '(evil-window-split :which-key "split horizontal")
   "wv" '(evil-window-vsplit :which-key "split vertical")
   "wd" '(evil-window-delete :which-key "delete window")
   "wm" '(delete-other-windows :which-key "maximize window")))

(provide 'my-keybindings)
