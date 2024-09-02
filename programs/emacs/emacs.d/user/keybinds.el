(require 'bind-key)

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
