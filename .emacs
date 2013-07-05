;; Am I speedycat?
(modify-frame-parameters nil '((wait-for-wm . nil)))

;; Set up us the bomb
(add-to-list 'load-path "~/.emacs.d/site-lisp")

;; Don't display the emacs splash
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)

;; Deploy weapons of mass destruction
(load-library "site-load")
(load-library "site-modes")
(load-library "site-faces")
(load-library "site-keys")
(load-library "site-hooks")
(load-library "site-terminal")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((use-hard-newlines . 0)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
