(use-package org
  :config
  (setq org-directory "~/Sync/org"
	org-agenda-files '("~/Sync/org/agenda.org")
	org-log-done 'time
	
	;; Better default states for tasks
	org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))

	org-refile-targets '((org-agenda-files :maxlevel . 3)
                             (org-files-list :maxlevel . 3))

	org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "QUESTION(q)" "|" "DONE(d)" "ANSWERED(a)" "CANCELLED(c)"))
	org-capture-templates
	'(("t" "Todo" entry (file+headline "~/Sync/org/agenda.org" "Tasks")
	   "* TODO %?\n  %i\n  %a")
	  ("n" "Note" entry (file "~/Sync/org/notes.org")
	   "* %? :note:\n  %U\n  %i\n  %a")
	  ("j" "Journal" entry (file+datetree "~/Sync/org/journal.org")
	   "* %?\nEntered on %U\n  %i\n  %a")
	  ("q" "Question" entry (file+headline "~/Sync/org/questions.org" "Questions")
	   "* QUESTION %?\n  %U\n  %i\n  %a"))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-roam
  :config
  (setq org-roam-directory "~/Sync/org/roam")
  (org-roam-db-autosync-mode))

(my-leader-def
  :keymaps 'org-mode-map
  :prefix "SPC m"   ; Local leader key for org-mode
  
  ;; Org structure editing - avoiding Meta key
  "[" '(org-promote-subtree :which-key "promote subtree")
  "]" '(org-demote-subtree :which-key "demote subtree")
  "{" '(org-move-subtree-up :which-key "move subtree up")
  "}" '(org-move-subtree-down :which-key "move subtree down")
  "r" '(org-refile :which-key "refile subtree")
  "t" '(org-todo :which-key "cycle todo state")
  "." '(org-time-stamp :which-key "insert timestamp")
  "d" '(org-deadline :which-key "set deadline")
  "s" '(org-schedule :which-key "schedule todo"))


(use-package gptel
  :config
  (setq gptel-default-mode 'org-mode))


(my-leader-def
  :keymaps 'org-mode-map
  :prefix "SPC m"
  "g" '(gptel-send :which-key "send to GPT")
  "G m" '(gptel-menu :which-key "GPT menu"))

(defun read-openrouter-token ()
  "Read OpenRouter API token from ~/.openrouter-token file."
  (with-temp-buffer
    (insert-file-contents (expand-file-name "~/.openrouter-token"))
    (string-trim (buffer-string))))


(gptel-make-openai "OpenRouter"               ;Any name you want
  :host "openrouter.ai"
  :endpoint "/api/v1/chat/completions"
  :stream t
  :key 'read-openrouter-token
  :models '(sao10k/l3.3-euryale-70b
	    openai/o1
	    google/gemini-2.0-flash-exp:free
	    qwen/qwq-32b-preview
	    openai/gpt-4o-2024-11-20
	    anthropic/claude-3.5-haiku-20241022:beta
	    anthropic/claude-3.5-sonnet:beta
            ))


(defun my/collect-llm-context ()
  "Collect all headings tagged with 'llm_context' from agenda files."
  (let ((context ""))
    (dolist (file org-agenda-files)
      (with-current-buffer (or (find-buffer-visiting file)
                              (find-file-noselect file))
        (org-map-entries
         (lambda ()
           (setq context (concat context "\n"
                                (org-get-heading t t t t) "\n"
                                (org-get-entry))))
         "llm_context")))
    context))


(my-leader-def
  :keymaps 'org-mode-map
  :prefix "SPC m"
  "G d" '(my/start-llm-dialogue :which-key "start dialogue with context"))
(provide 'my-org)
