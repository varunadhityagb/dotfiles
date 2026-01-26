;;; modules/theme.el -*- lexical-binding: t; -*-

;; Theme settings
(setq doom-theme 'doom-matugen)
(setq custom-safe-themes t)

;; Theme auto-reload
(defvar my/theme-file-mtime nil)
(defvar my/theme-file (expand-file-name "../themes/doom-matugen-theme.el" doom-user-dir))

(defun my/reload-matugen-theme-if-changed ()
  "Reload matugen theme if the theme file has been modified."
  (when (file-exists-p my/theme-file)
    (let ((current-mtime (file-attribute-modification-time
                          (file-attributes my/theme-file))))
      (when (and current-mtime
                 (or (not my/theme-file-mtime)
                     (time-less-p my/theme-file-mtime current-mtime)))
        (setq my/theme-file-mtime current-mtime)
        (load-theme 'doom-matugen t)
        (message "Matugen theme reloaded!")))))

(defun my/reload-theme ()
  "Manually reload the doom-matugen theme."
  (interactive)
  (load-theme 'doom-matugen t)
  (message "Theme reloaded!"))

;; Auto-reload hooks
(add-hook 'server-after-make-frame-hook #'my/reload-matugen-theme-if-changed)
(add-hook 'focus-in-hook #'my/reload-matugen-theme-if-changed)

(provide 'theme)
;;; theme.el ends here
