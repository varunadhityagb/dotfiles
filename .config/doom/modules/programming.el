;;; modules/programming.el -*- lexical-binding: t; -*-

;; Python - Ruff formatting
(require 'ruff-format)
(add-hook 'python-mode-hook 'ruff-format-on-save-mode)

;; C/C++ - LSP configuration
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(setq lsp-clients-clangd-args '("-compile-commands-dir=~/Syncthing/CtrlP/"))

;; DAP mode for debugging
(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-gdb-lldb))

;; Web mode for Astro files
(add-to-list 'auto-mode-alist '("\\.astro\\'" . web-mode))

;; Projectile cleanup
(defun projectile-gc-projects ()
  "Remove non-existent directories from `projectile-known-projects'."
  (interactive)
  (let ((old-projects projectile-known-projects))
    (setq projectile-known-projects
          (--select (file-exists-p it) old-projects))
    (unless (= (length old-projects) (length projectile-known-projects))
      (message "Projectile: Cleaned up %d non-existent project(s)."
               (- (length old-projects) (length projectile-known-projects))))))

;; TRAMP configuration
(setq tramp-default-proxies-alist
      '((".*" "\\`root\\'" "/ssh:%h:")))
(setq tramp-allow-unsafe-temporary-files t)
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

(provide 'programming)
;;; programming.el ends here
