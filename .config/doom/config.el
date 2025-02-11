;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-theme 'doom-monokai-octagon)

(setq display-line-numbers-type 'relative)

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

(after! org
  (set-face-attribute 'org-level-1 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-2 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-3 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-document-title nil :height 1.5 :weight 'bold))

(after! tex
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master t)

  (setq TeX-command-default "LatexMk"))

(use-package! latex-preview-pane
  :after latex
  :commands latex-preview-pane-mode
  :init
  (setq latex-preview-pane-multifile-mode 'auctex)
  (setq latex-preview-pane-update-delay 0.1)
  :config
  (setq latex-preview-pane-pdf-view-command "zathura")

  ;; Enable the preview pane
  (latex-preview-pane-enable))

(after! org (setq org-babel-default-header-args:java '((:dir . nil) (:results . "value")))) (org-babel-do-load-languages 'org-babel-load-languages '((java . t)))


;; Better auto-save configuration
(add-hook! 'latex-mode-hook
  (lambda ()
    (unless TeX-master
      (setq TeX-master (buffer-file-name)))

    (auto-save-mode +1)
    (setq auto-save-timeout 1)
    (setq auto-save-interval 1)))

(setq exec-path (append exec-path '("/usr/local/textlive/2024/bin/x86_64/pdflatex")) )


(map! :leader
      :desc "Open vterm" "o t" #'vterm)

(map! :leader
      :localleader
      "p" #'latex-preview-pane-mode)
