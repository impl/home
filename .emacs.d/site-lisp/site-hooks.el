; Set up hooks

;; Load whitespace-stripping libraries
;(autoload 'nuke-trailing-whitespace "whitespace" nil t)

;; Strip whitespace from the end of lines
;(add-hook 'mail-send-hook 'nuke-trailing-whitespace)
;(add-hook 'write-file-hooks 'nuke-trailing-whitespace)

;; Set up indentation hooks for C-derived modes
(defconst nf-c-mode-style
  '((c-tab-always-indent    . t)
    (c-hanging-braces-alist . ((substatement-open . (after))
			       (defun-open . (after))
			       (brace-list-open)))
    (c-hanging-colons-alist . ((member-init-intro before)
                               (inher-intro)
                               (case-label after)
                               (label after)
                               (access-label after)))
    (c-cleanup-list         . (scope-operator
                               defun-close-semi))
    (c-offsets-alist        . ((arglist-intro         . +)
                               (arglist-cont-nonempty . +)
                               (arglist-close         . 0)
                               (substatement-open     . 0)
                               (case-label            . 0)
                               (block-open            . 0)
                               (defun-block-intro     . +)
                               (statement-block-intro . +)
                               (substatement          . +)
                               (knr-argdecl-intro     . -))))
  "Noah Fontes's C Style")

(defun nf-c-mode-hook ()
  (c-add-style "nf" nf-c-mode-style t))
(add-hook 'c-mode-common-hook 'nf-c-mode-hook)

;; php-mode is a little retarded about commenting, so add # to the list of
;; valid comment starts
(add-hook 'php-mode-hook (lambda ()
                           (modify-syntax-entry ?/ ". 124b" php-mode-syntax-table)
                           (modify-syntax-entry ?* ". 23" php-mode-syntax-table)
                           (modify-syntax-entry ?# "< b" php-mode-syntax-table)
                           (modify-syntax-entry ?\n "> b" php-mode-syntax-table)))
