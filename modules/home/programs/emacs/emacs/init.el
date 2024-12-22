(require 'package)

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(require 'my-ui)
(require 'my-evil)
(require 'my-completion)
(require 'my-keybindings)

(require 'my-development)
(require 'my-org)
(require 'my-projects)
