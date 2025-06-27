;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16 :weight 'regular))
(setq doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 14 :weight 'regular))

(setq doom-theme 'doom-one)
;; (add-to-list 'default-frame-alist '(alpha-background . 90))

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")
(setq org-latex-src-block-backend 'listings)

(setq conda-anaconda-home (getenv "ANACONDA_HOME")
      conda-home-candidates
      (list "~/.anaconda"))

;; Set pdflatex as the default compilation method
(setq +latex-default-compilation-method 'pdflatex)

;; Ensure SyncTeX is enabled and pdflatex is used
(after! tex
  (setq TeX-command-default "pdflatex")
  (setq TeX-parse-self t)
  (setq TeX-auto-save t)
  (setq-default TeX-master t)

  (add-to-list 'TeX-command-list
               '("PdfLaTeX" "pdflatex -synctex=1 %s" TeX-run-TeX nil t))

  ;; Set the default LaTeX engine for pdflatex
  (setq TeX-command-list
        (append TeX-command-list
                '(("PdfLaTeX" "pdflatex -synctex=1 %s" TeX-run-TeX nil t)))))

(setq TeX-PDF-mode t)  ;; Ensure PDF output is generated

;; Ensure pdflatex is in the path if necessary
(setq exec-path (append exec-path '("/usr/local/texlive/2024/bin/x86_64")))

;; PDF tools setup for SyncTeX support
(after! pdf-tools
  (setq pdf-view-resize-factor 1.1)  ;; Optional, tweak the zoom level
  (add-to-list 'revert-without-query ".pdf"))

;;(define-key pdf-view-mode-map (kbd "M-<mouse-1>") #'pdf-view-sync-backward)
;;(define-key pdf-view-mode-map (kbd "M-<mouse-3>") #'pdf-view-sync-forward)

(use-package! pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :init (pdf-loader-install)
  :mode "\\.pdf\\'"
  :bind (:map pdf-view-mode-map
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-previous-page)
              ("C-+" . pdf-view-enlarge)
              ("C--" . pdf-view-shrink))
  :config
  (setq pdf-view-resize-factor 1.1)  ;; Optional, adjust zoom factor
  (add-to-list 'revert-without-query ".pdf")
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (when (eq major-mode 'pdf-view-mode)
                (setq pdf-sync-embed-pdf t))))
  ;; Bind keys for forward and backward SyncTeX search
  (define-key pdf-view-mode-map (kbd "M-<mouse-1>") #'pdf-view-sync-backward)
  (define-key pdf-view-mode-map (kbd "M-<mouse-3>") #'pdf-view-sync-forward))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((octave . t)))

(setq confirm-kill-emacs nil)

(require 'ob-async)

(load! "babel-config.el")

(after! org
  (set-face-attribute 'org-level-1 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-2 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-3 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-document-title nil :height 1.5 :weight 'bold))

(use-package! latex-preview-pane
  :after latex
  :commands latex-preview-pane-mode
  :init
  (setq latex-preview-pane-multifile-mode 'auctex)
  (setq latex-preview-pane-update-delay 0.1)
  :config
  (setq latex-preview-pane-pdf-view-command "zathura")
  (setq latex-preview-pane-latex-command "pdflatex -synctex=1 -interaction=nonstopmode %f")
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

(defun insert-setupfile()
  "Inserts setupfile"
  (interactive)
  (insert "#+SETUPFILE:/home/varunadhityagb/.config/doom/org-setup.org\n"))

(map! :leader
      :desc "Open vterm" "o t" #'vterm)

(map! :leader
      "b a b i" #'insert-setupfile )

;; (setq (centaur-tabs-mode 'nil))

(after! org
  (add-to-list 'org-file-apps '("\\.pdf\\'" . "zathura \"%s\"")))

(setq org-src-fontify-natively t)
(setq org-latex-listings 'minted)
(setq org-latex-packages-alist '(("" "minted")))
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"))
(setq fancy-splash-image (concat doom-private-dir "varun.png"))
