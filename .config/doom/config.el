;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-octagon)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq conda-anaconda-home (getenv "ANACONDA_HOME")
      conda-home-candidates
      (list "~/.anaconda"))


(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :mode "\\.pdf\\'"
  :bind (:map pdf-view-mode-map
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-previous-page)
              ("C-+" . pdf-view-enlarge)
              ("C--" . pdf-view-shrink))
  :init (pdf-loader-install)
  :config
  (add-to-list 'revert-without-query ".pdf"))

(add-hook 'pdf-view-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

;; Enable LSP
(lsp)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((octave . t)))

;; Comment line
(map! :leader "z" #'comment-line)

(setq +latex-viewers '(zathura))

(setq confirm-kill-emacs nil)

(require 'ob-async)

(load! "babel-config.el")
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! org
  (set-face-attribute 'org-level-1 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-2 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-3 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-document-title nil :height 1.5 :weight 'bold))

;; Set up TeX-master properly
(after! tex
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  ;; Tell AUCTeX to use the current file as master by default
  (setq-default TeX-master t)

  ;; Use latexmk as the default command
  (setq TeX-command-default "LatexMk"))

;; Configure latex-preview-pane
(use-package! latex-preview-pane
  :after latex
  :commands latex-preview-pane-mode
  :init
  (setq latex-preview-pane-multifile-mode 'auctex)
  (setq latex-preview-pane-update-delay 0.1)
  :config
  ;; Set the default program for opening PDFs
  (setq latex-preview-pane-pdf-view-command "zathura")

  ;; Enable the preview pane
  (latex-preview-pane-enable))


;; Better auto-save configuration
(add-hook! 'latex-mode-hook
  (lambda ()
    ;; Set the master file to the current file if not already set
    (unless TeX-master
      (setq TeX-master (buffer-file-name)))

    ;; Enable auto-save
    (auto-save-mode +1)
    (setq auto-save-timeout 1)
    (setq auto-save-interval 1)))

;; (setq org-latex-pdf-process
;;       '("/usr/local/textlive/2024/bin/x86_64/pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;         "/usr/local/textlive/2024/bin/x86_64/pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;         "/usr/local/textlive/2024/bin/x86_64/pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq exec-path (append exec-path '("/usr/local/textlive/2024/bin/x86_64/pdflatex")) )
;; Force update function
(defun force-latex-preview-update ()
  (interactive)
  (when (bound-and-true-p latex-preview-pane-mode)
    (latex-preview-pane-update)))

;; Bind it to a key
(map! :map latex-mode-map
      :localleader
      "p" #'force-latex-preview-update)


(map! :leader
      :desc "Open vterm" "o t" #'vterm)
