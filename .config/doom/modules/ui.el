;;; modules/ui.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
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

;; Font configuration
(setq doom-font (font-spec :family "IosevkaTermSlab Nerd Font" :size 20 :weight 'regular))
(setq doom-variable-pitch-font (font-spec :family "SF Pro Text" :size 24 :weight 'regular))

;; Transparency
(add-to-list 'default-frame-alist '(alpha-background . 70))

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Dashboard customization
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

;; Dired
(add-hook 'dired-mode-hook 'dired-hide-details-mode t)

;; Using fish
(setq vterm-shell "/usr/bin/fish")

(use-package! ultimate-print
  :commands (ultimate-print ultimate-print-repeat-last ultimate-print-file)
  :config
  ;; Set your default printer if desired
  (setq ultimate-print-default-printer nil)  ; nil uses system default

  ;; Set default number of copies
  (setq ultimate-print-default-copies 1)

  ;; Optional: Configure PostScript printing
  (setq ps-paper-type 'letter)  ; or 'a4
  (setq ps-print-header t)
  (setq ps-print-color-p t))

(provide 'ui)
;;; ui.el ends here
