;; Support additional modules
(let ((default-directory "~/.emacs.d/site-lisp/opt"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Packages we always want installed
(dolist (package '(popup fuzzy auto-complete gist gh php-mode scss-mode))
  (unless (package-installed-p package)
    (package-install package)))
