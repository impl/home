; Configuration for ansi-term

;; This is a custom version of term.el that fixes the stupid escape sequence
;; crap that doesn't work correctly because rms is an incompetent fuckwad
(require 'nf-term)

(defun nf-terminal (buffer-name command &rest arguments)
  (let ((full-buffer-name (concat "terminal@" buffer-name))
        buffer)
    (setq buffer (generate-new-buffer (concat "*" full-buffer-name "*")))
    (save-excursion
      (set-buffer buffer)

      (term-mode)
      (term-exec buffer full-buffer-name command nil arguments)
      (term-char-mode)
      (term-set-escape-char ?\C-z)
      (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix)

      (make-local-variable 'nf-specified-buffer-name)
      (setq nf-specified-buffer-name full-buffer-name)

      (make-local-variable 'nf-old-default-directory)
      (setq nf-old-default-directory nil)

      (switch-to-buffer buffer))))

(defun nf-terminal-here ()
  (interactive)
  (nf-terminal system-name "zsh"))

;; Load custom terminal locations (not in this script so it can be easily
;; versioned publicly)
(defmacro nf-terminal-at (place &rest command)
  `(defun ,(intern (concat "nf-terminal-at-" (symbol-name place))) ()
     (interactive)
     (nf-terminal ,(symbol-name place) ,@command)))
(when (file-exists-p "~/.emacs.d/terminal/locations.el")
  (load "~/.emacs.d/terminal/locations.el"))

;; For most hosts, we should have information about the current hostname,
;; username, process, and directory
(defadvice term-emulate-terminal (after advise-term-buffer-name)
  (when (and (local-variable-p 'nf-specified-buffer-name)
             (not (string= default-directory nf-old-default-directory)))
    (rename-buffer
     (generate-new-buffer-name
      (concat "*" nf-specified-buffer-name ":" default-directory "*")))
    (setq nf-old-default-directory default-directory)))
(ad-activate 'term-emulate-terminal)
