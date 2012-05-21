; Initialize some basic modes

;; Set up the titlebar
(setq frame-title-format (list "%b [" 'mode-name "] (" 'invocation-name "@" 'system-name ")"))

;; The following are much faster when specified in .Xdefaults:
;;  Emacs.geometry: 100x40
;;  Emacs.menuBar: off
;;  Emacs.toolBar: 0
;;  Emacs.verticalScrollBars: off

;; Switch to Unicode
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
;;; Set up clipboard support
(setq x-select-request-type '(UTF8_STRING COMPOUND_STRING TEXT STRING))
(set-clipboard-coding-system 'utf-8)
;;; Set up terminal support
(defadvice ansi-term (after advise-ansi-term-coding-system)
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

;; Remove the menubar
(menu-bar-mode 0)

;; Remove the toolbar
(tool-bar-mode 0)

;; Remove the scrollbar
(scroll-bar-mode 0)

;; Parenthesis matching
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)
(show-paren-mode t)

;; Show columns
(setq column-number-mode t)

;; Font-lock mode
(setq global-font-lock-mode t)

;; Unset indent-tabs mode
(setq-default indent-tabs-mode nil)

;; Display trailing whitespace
(setq whitespace-style '(trailing))
(global-whitespace-mode t)
;(setq-default show-trailing-whitespace t)

;; Always strip trailing whitespace when necessary
;(set-variable 'nuke-trailing-whitespace-p t)

;; Set up indentation
(setq-default standard-indent 4)
;(set-variable 'c-basic-offset 4)

;; Copy to X's clipboard
(set-variable 'x-select-enable-clipboard t)

;; Disable semantic
(setq semanticdb-default-save-directory "~/.semanticdb")

;; Disable backup files
(setq make-backup-files nil)

;; Replace emacs's default undo-mode with undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; Enable URL highlighting for all modes
;;; This is like a global minor mode, but goto-address-mode doesn't provide one out of the box
(add-hook 'after-change-major-mode-hook
          '(lambda() (goto-address-mode)))
(setq goto-address-mail-regexp "\`\'") ; Not interested in sending e-mail from emacs

;; Set up nxml-mode
(add-to-list 'auto-mode-alist
             (cons (concat "\\." (regexp-opt '("xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
                   'nxml-mode))
(add-to-list 'magic-mode-alist
             '("<\\?xml " . nxml-mode))
(unify-8859-on-decoding-mode)
(mapc (lambda (list)
        (mapc (lambda (pair)
                (if (or (eq (cdr pair) 'xml-mode)
                        (eq (cdr pair) 'sgml-mode)
                        (eq (cdr pair) 'html-mode))
                    (setcdr pair 'nxml-mode)))
              list))
      (list auto-mode-alist magic-mode-alist))

(eval-after-load "nxml-mode"
  '(progn
     (require 'rng-loc)
     (add-to-list 'rng-schema-locating-files "~/.emacs.d/site-lisp/site-schemas.xml")))

;; For some reason, nXML refuses to acknowledge the value of standard-indent
(setq-default nxml-child-indent 4)

;; Use smart indentation
(require 'dtrt-indent)

;; XML indentation
(add-to-list 'dtrt-indent-language-syntax-table
             '(nf-xml ("<\\[CDATA\\[" 0 "\\]\\]>" nil) ; CDATA
                      ("\""           0 "\""      nil) ; Strings
                      ("'"            0 "'"       nil) ; Strings
                      ("<!--"         0 "-->"     nil) ; Comments
                      ("<!DOCTYPE"    0 ">"       nil) ; DOCTYPE
                      ("<\\?"         0 "\\?>"    nil) ; E.g. XML declaration
                      ("<[^\\s-]+"    0 ">"       nil))) ; Tags
(add-to-list 'dtrt-indent-hook-mapping-list '(xml-mode nf-xml sgml-indent-step))     ; XML
(add-to-list 'dtrt-indent-hook-mapping-list '(nxml-mode nf-xml nxml-child-indent))   ; XML (nXML)

;; CSS indentation
(add-to-list 'dtrt-indent-language-syntax-table
             '(nf-css ("\""     0 "\""     nil "\\\\.")
                      ("'"      0 "'"      nil "\\\\.")
                      ("[/][*]" 0 "[*][/]" nil)
                      ("{"      0 "}"      t)))
(add-to-list 'dtrt-indent-hook-mapping-list '(css-mode nf-css cssm-indent-level))

(dtrt-indent-mode t)

;; "Smart" tabbing when we're forced to work with files that need indent-tabs-mode
(setq cua-auto-tabify-rectangles nil)

(defadvice align (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))

(defadvice align-regexp (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))

(defadvice indent-relative (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))

(defadvice indent-according-to-mode (around smart-tabs activate)
  (let ((indent-tabs-mode indent-tabs-mode))
    (if (memq indent-line-function
              '(indent-relative
                indent-relative-maybe))
        (setq indent-tabs-mode nil))
    ad-do-it))

(defmacro smart-tabs-advice (function offset)
  (defvaralias offset 'tab-width)
  `(defadvice ,function (around smart-tabs activate)
     (cond
      (indent-tabs-mode
       (save-excursion
         (beginning-of-line)
         (while (looking-at "\t*\\( +\\)\t+")
           (replace-match "" nil nil nil 1)))
       (setq tab-width tab-width)
       (let ((tab-width fill-column)
             (,offset fill-column))
         ad-do-it))
      (t
       ad-do-it))))

;; "Smart" tabbing for C
;(smart-tabs-advice c-indent-line c-basic-offset)
;(smart-tabs-advice c-indent-region c-basic-offset)

;; "Smart" tabbing for Python
;(smart-tabs-advice python-indent-line-1 python-indent)

;; Sometimes I like to delete things
(put 'erase-buffer 'disabled nil)

;; Some extra language modes that aren't bundled with emacs
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

(require 'scala-mode-auto)
(eval-after-load "scala-mode"
  '(progn
     (define-key scala-mode-map [f1] nil)))

(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests." t)
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; Automatic completion of input
(require 'popup)
(require 'fuzzy)
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-show-menu 1.5)
(setq ac-ignore-case t)
(define-key ac-mode-map (kbd "M-SPC") 'auto-complete)

(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "<down>") 'ac-next)
(define-key ac-menu-map (kbd "<up>") 'ac-previous)

(setq ac-use-quick-help nil)
