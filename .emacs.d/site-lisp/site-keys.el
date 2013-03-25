;; Function keys
(global-set-key [f1] 'nf-exhume-buffer)
(global-set-key [(shift f1)] 'nf-bury-buffer)
;(global-set-key [f1] 'next-buffer)
;(global-set-key [(shift f1)] 'previous-buffer)
(global-set-key [f2] 'save-some-buffers)
(global-set-key [f3] 'kill-this-buffer)
(global-set-key [(shift f3)] 'kill-some-buffers)
(global-set-key [f4] 'recenter)
(global-set-key [f5] 'what-line)
(global-set-key [f9] 'undo)
(global-set-key [f10] 'split-window-vertically)
(global-set-key [(shift f10)] 'split-window-horizontally)
(global-set-key [f11] 'delete-other-windows)
(global-set-key [(shift f11)] 'delete-window)
(global-set-key [f12] 'other-window)
(global-set-key [(shift f12)] 'other-frame)

; Long live Emacs 18!
(defun nf-exhume-buffer ()
  (interactive)
  (let ((new-list (buffer-list (selected-frame))))
    (while (string-match
            "^\\s-*\\*.+\\*$"
            (buffer-name (car (reverse new-list))))
      (setq new-list (append
                      (list (car (reverse new-list)))
                      (reverse (cdr (reverse new-list))))))
    (when (not (eq (car (reverse new-list))
                   (current-buffer)))
      (modify-frame-parameters (selected-frame)
                               (list (cons 'buffer-list new-list)))
      (switch-to-buffer (car (reverse new-list))))))

(defun nf-bury-buffer ()
  (interactive)
  (let ((new-list (buffer-list (selected-frame))))
    (while
        (progn
          (setq new-list (append
                          (cdr new-list)
                          (list (car new-list))))
          (string-match
           "^\\s-*\\*.+\\*$"
           (buffer-name (car new-list)))))
    (when (not (eq (car new-list)
                   (current-buffer)))
      (modify-frame-parameters (selected-frame)
                               (list (cons 'buffer-list new-list)))
      (switch-to-buffer (car new-list)))))

;; Enter should indent as well
(global-set-key [?\r] 'newline-and-indent)

;; Fancy shortcut for file annotations
(global-set-key (kbd "C-c C-l") 'org-annotate-file)
