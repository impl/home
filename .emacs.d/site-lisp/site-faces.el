;; Default font (prevents future breakage)
;(set-default-font "-adobe-courier-medium-r-normal--17-120-100-100-m-100-iso8859-1")
;(set-default-font "Consolas-8:weight=bold")

;; Face to use with everything
(make-face 'default)

(set-face-background 'default "black")
(set-face-foreground 'default "grey90")

(copy-face 'default 'left-margin)
(copy-face 'default 'right-margin)

(set-face-foreground 'isearch "grey20")
(set-face-background 'isearch "#AFB4C4")

(set-face-foreground 'mode-line "grey20")
(set-face-background 'mode-line "#ECEDEE")

(set-face-foreground 'highlight "grey20")
(set-face-background 'highlight "#AFB4C4")

(set-face-foreground 'tool-bar "grey20")
(set-face-background 'tool-bar "#ECEDEE")

(set-face-foreground 'scroll-bar "grey20")
(set-face-background 'scroll-bar "#ECEDEE")

;; Make the background black
(set-background-color "grey10")

;; Pointer/cursor colors
(set-cursor-color "grey90")
(set-mouse-color "grey90")

;; If we're in a window manager, support custom syntax highlighting
(set-face-foreground 'show-paren-match "#CC8C32")

;; Shells have a custom color scheme
(setq ansi-term-color-vector [unspecified "black" "#e40045" "#98fb98" "#fafad2" "#20b2aa" "#bc8f8f" "#32cd32" "white"])

;; Force URLs to use sane faces
(eval-after-load "goto-address"
  '(progn
     (setq goto-address-mail-face 'link)
     (setq goto-address-mail-mouse-face 'highlight)
     (setq goto-address-url-face 'link)
     (setq goto-address-url-mouse-face 'highlight)))

;; For emacsclient support
(defun nf-apply-window-system-faces (&optional frame)
  ;; Make things use the prettier font
  (set-face-font 'default "DejaVu Sans Mono-10" frame)

  ;; Parentheses matching
  (set-face-background 'show-paren-match nil frame)

  (set-face-foreground 'show-paren-mismatch "grey90" frame)
  (set-face-background 'show-paren-mismatch "#7A1A0C" frame)

  ;; Whitespace
  (set-face-background 'whitespace-trailing nil frame)
  (set-face-attribute 'whitespace-trailing frame :underline t)

  ;; Syntax highlighting
  ;;; Built-ins
  (set-face-foreground 'font-lock-builtin-face "grey90" frame)

  ;;; Preprocessor directives
  (set-face-foreground 'font-lock-preprocessor-face "grey70" frame)
  (set-face-background 'font-lock-preprocessor-face "grey20" frame)

  ;;; Comments
  (set-face-foreground 'font-lock-comment-face "grey40" frame)
  (set-face-attribute 'font-lock-comment-face frame :slant 'italic)

  (set-face-foreground 'font-lock-doc-face "grey70" frame)
  (set-face-attribute 'font-lock-doc-face frame :slant 'italic)

  ;;; Keywords
  (set-face-foreground 'font-lock-keyword-face "#8EA4DB" frame)

  ;;; Strings
  (set-face-foreground 'font-lock-string-face "#499E57" frame)

  ;;; Constants
  (set-face-foreground 'font-lock-constant-face "#CC8C32" frame)
  (set-face-background 'font-lock-constant-face "grey20" frame)

  ;;; Types
  (set-face-foreground 'font-lock-type-face "#9BB3F0" frame)
  (set-face-attribute 'font-lock-type-face frame :slant 'normal)

  ;;; Identifiers
  (set-face-foreground 'font-lock-function-name-face "#CBD5F0" frame)
  (set-face-attribute 'font-lock-function-name-face frame :weight 'bold :slant 'normal)

  ;;; Variables
  (set-face-foreground 'font-lock-variable-name-face "#CBD5F0" frame)

  ;;; URLs
  (set-face-foreground 'link "grey70" frame)
  (set-face-attribute 'link frame :underline t)
  (set-face-foreground 'highlight "grey50" frame)
  (set-face-background 'highlight nil frame)

  ;;; Auto-completion
  (eval-after-load "auto-complete"
    '(progn
       (set-face-background 'ac-candidate-face "grey20" frame)
       (set-face-foreground 'ac-candidate-face "grey90" frame)
       (set-face-background 'ac-selection-face "#8EA4DB" frame)
       (set-face-foreground 'ac-selection-face "grey20" frame))))

(add-hook 'after-make-frame-functions
          '(lambda (frame)
             (select-frame-set-input-focus frame)
             (when (window-system frame)
               (nf-apply-window-system-faces frame))))

;; For non-daemon startup
(when window-system
  (nf-apply-window-system-faces))
