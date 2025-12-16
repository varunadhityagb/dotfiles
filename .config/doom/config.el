;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "TerminessTTF Nerd Font Mono" :size 20 :weight 'regular))
(setq doom-variable-pitch-font (font-spec :family "TerminessTTF Nerd Font Mono" :size 24 :weight 'regular))

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
                         :key "REDACTED"
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

(defvar my/server-local-ip "192.168.1.4")
(defvar my/server-tailscale-ip "100.70.52.122")

(defun my/on-home-lan-p ()
  "Return non-nil if the system is on 192.168.1.x network."
  (let ((output (shell-command-to-string "ip -4 addr show")))
    (string-match-p "192\\.168\\.1\\." output)))

(defun my/server-url (port)
  "Return correct URL (LAN or Tailscale) for PORT."
  (format "http://%s:%s"
          (if (my/on-home-lan-p)
              my/server-local-ip
            my/server-tailscale-ip)
          port))

(defun my/open-server (port)
  "Open the correct local/tailscale server link for PORT."
  (browse-url (my/server-url port)))


(defun doom-dashboard-widget-footer ()
  (insert
   "\n"
   (+doom-dashboard--center
    (- +doom-dashboard--width 4)
    (with-temp-buffer

      ;; VNC (7900)
      (insert-text-button
       (or (nerd-icons-mdicon "nf-md-remote_desktop"
                              :face 'doom-dashboard-footer-icon :height 1.3)
           (propertize "VNC" 'face 'doom-dashboard-footer))
       'action (lambda (_) (my/open-server 7900))
       'follow-link t
       'help-echo "Open VNC Browser")

      (insert "   ")

      ;; Deluge (8112)
      (insert-text-button
       (or (nerd-icons-mdicon "nf-md-download"
                              :face 'doom-dashboard-footer-icon :height 1.3)
           (propertize "Deluge" 'face 'doom-dashboard-footer))
       'action (lambda (_) (my/open-server 8112))
       'follow-link t
       'help-echo "Open Deluge Web UI")

      (insert "   ")

      ;; Jellyfin (8096)
      (insert-text-button
       (or (nerd-icons-mdicon "nf-md-video"
                              :face 'doom-dashboard-footer-icon :height 1.3)
           (propertize "Jellyfin" 'face 'doom-dashboard-footer))
       'action (lambda (_) (my/open-server 8096))
       'follow-link t
       'help-echo "Open Jellyfin")

      (insert "   ")

      ;; Vaultwarden (10380)
      (insert-text-button
       (or (nerd-icons-mdicon "nf-md-lock"
                              :face 'doom-dashboard-footer-icon :height 1.3)
           (propertize "Vaultwarden" 'face 'doom-dashboard-footer))
       'action (lambda (_) (browse-url  "https://vault.varunadhityagb.live"))
       'follow-link t
       'help-echo "Open Vaultwarden")

      (buffer-string)))
   "\n"))

(require 'org-tempo)

(add-to-list 'auto-mode-alist '("\\.astro\\'" . web-mode))
