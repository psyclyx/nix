(require 'bind-key)

(bind-keys
 :prefix-map cherub/file
 :prefix "C-c f"
 ("f" . counsel-find-file)
 ("r" . counsel-recentf)
 ("R" . rename-file)
 ("s" . save-buffer)
 ("d" . dired-jump)
 ("D" . dired))


(bind-keys
 :prefix-map cherub/help
 :prefix "C-c h"
 ("a" . apropos-command)
 ("i" . emacs-index-search))

(bind-keys
 :prefix-map cherub/window
 :prefix "C-c w"
 ("d" . delete-window)
 ("h" . windmove-left)
 ("j" . windmove-down)
 ("k" . windmove-up)
 ("l" . windmove-right)
 ("v" . split-window-horizontally)
 ("s" . split-window-vertically))

(bind-keys
 :prefix-map cherub/magit
 :prefix "C-c g"
 ("s" . magit-status)
 ("l" . magit-log))

(bind-key "C-c p" 'projectile-command-map)
