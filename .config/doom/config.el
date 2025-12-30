;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "DaddyTimeMono Nerd Font" :size 18 :weight 'regular))
(setq doom-variable-pitch-font (font-spec :family "DaddyTimeMono Nerd Font" :size 20 :weight 'regular))

(setq doom-theme 'doom-matugen)
(add-to-list 'default-frame-alist '(alpha-background . 50))

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")
(setq org-latex-src-block-backend 'listings)
(setq confirm-kill-emacs nil)
(load! "babel-config.el")

(require 'ob-async)
(require 'ruff-format)

(add-hook 'python-mode-hook 'ruff-format-on-save-mode)

;; setup file
(defun insert-setupfile()
  "Inserts setupfile"
  (interactive)
  (insert "#+SETUPFILE:/home/varunadhityagb/.config/doom/org-setup.org\n"))

(map! :leader
      "b a b i" #'insert-setupfile )


(after! org
  (set-face-attribute 'org-level-1 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-2 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-3 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-document-title nil :height 1.5 :weight 'bold))

(after! org (setq org-babel-default-header-args:java '((:dir . nil) (:results . "value")))) (org-babel-do-load-languages 'org-babel-load-languages '((java . t)))


(map! :leader
      :desc "Open vterm" "o t" #'vterm)

(after! org
  (add-to-list 'org-file-apps '("\\.pdf\\'" . "zathura \"%s\"")))

(setq org-src-fontify-natively t)
(setq org-latex-listings 'minted)
(setq org-latex-packages-alist '(("" "minted")))
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"))

;; (setq fancy-splash-image (concat doom-private-dir "varun.png"))

(defun +latex/clean ()
  "Delete auxiliary LaTeX files in the current directory."
  (interactive)
  (let ((clean-extensions '("aux" "fdb_latexmk" "fls" "log" "out" "synctex.gz"
                            "toc" "bbl" "blg"))
        (base (file-name-sans-extension (buffer-file-name))))
    (dolist (ext clean-extensions)
      (let ((file (concat base "." ext)))
        (when (file-exists-p file)
          (delete-file file))))
    (when (file-directory-p ".auctex-auto")
      (delete-directory ".auctex-auto" t))
    (message "Cleaned up LaTeX auxiliary files.")))

(map! :map LaTeX-mode-map
      :localleader
      :desc "Clean LaTeX aux files" "C" #'+latex/clean)

(map! :leader
      :desc "Find file at point"
      "f o" #'ffap)


(use-package! gptel
  :config
  (setq! gptel-model 'gemini-2.5-pro
         gptel-backend (gptel-make-gemini "Gemini"
                         :key "AIzaSyDNn76HfaWKpAVqlhVlLRixLbycrz_eNNA"
                         :stream t))
  gptel-default-mode 'org-mode)

(map! :leader
      :n "o g" #'gptel
      :v "o g" #'gptel-rewrite)

;; for custom theme
(setq custom-safe-themes t)

(defvar my/theme-file-mtime nil)
(defvar my/theme-file (expand-file-name "themes/doom-matugen-theme.el" doom-user-dir))

(defun my/reload-matugen-theme-if-changed ()
  (when (file-exists-p my/theme-file)
    (let ((current-mtime (file-attribute-modification-time
                          (file-attributes my/theme-file))))
      (when (and current-mtime
                 (or (not my/theme-file-mtime)
                     (time-less-p my/theme-file-mtime current-mtime)))
        (setq my/theme-file-mtime current-mtime)
        (load-theme 'doom-matugen t)
        (message "Matugen theme reloaded!")))))

(add-hook 'server-after-make-frame-hook #'my/reload-matugen-theme-if-changed)

(add-hook 'focus-in-hook #'my/reload-matugen-theme-if-changed)

(setq doom-theme 'doom-matugen)

(defun my/reload-theme ()
  (interactive)
  (load-theme 'doom-matugen t)
  (message "Theme reloaded!"))

(map! :leader
      :desc "Reload theme" "h h" #'my/reload-theme)


(add-hook 'dired-mode-hook 'dired-hide-details-mode t)

(defun projectile-gc-projects ()
  "Remove non-existent directories from `projectile-known-projects'."
  (interactive)
  (let ((old-projects projectile-known-projects))
    (setq projectile-known-projects
          (--select (file-exists-p it) old-projects))
    (unless (= (length old-projects) (length projectile-known-projects))
      (message "Projectile: Cleaned up %d non-existent project(s)."
               (- (length old-projects) (length projectile-known-projects))))))

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)


(require 'org-tempo)

(add-to-list 'auto-mode-alist '("\\.astro\\'" . web-mode))

(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(setq lsp-clients-clangd-args '("-compile-commands-dir=~/Syncthing/CtrlP/"))

(setq tramp-default-proxies-alist
      '((".*" "\\`root\\'" "/ssh:%h:")))
(setq tramp-allow-unsafe-temporary-files t)
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

(setq delete-by-moving-to-trash t)


(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-gdb-lldb))
