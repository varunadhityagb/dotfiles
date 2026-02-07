;;; modules/org-mode.el -*- lexical-binding: t; -*-

;; Org directory
(setq org-directory "~/org/")

;; Org babel
(require 'ob-async)
(setq org-latex-src-block-backend 'listings)
(setq org-src-fontify-natively t)
(setq org-src-window-setup 'reorganize-frame)

;; Org babel Java configuration
(after! org
  (setq org-babel-default-header-args:java '((:dir . nil) (:results . "value"))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((java . t)))

;; Org tempo for quick templates
(require 'org-tempo)

;; Org file apps
(after! org
  (add-to-list 'org-file-apps '("\\.pdf\\'" . "zathura \"%s\"")))

;; Org heading sizes
(after! org
  (set-face-attribute 'org-level-1 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-2 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-level-3 nil :height 1.1 :weight 'normal)
  (set-face-attribute 'org-document-title nil :height 1.5 :weight 'bold))

;; Setup file insertion function
(defun insert-setupfile()
  "Inserts setupfile"
  (interactive)
  (insert "#+SETUPFILE:/home/varunadhityagb/.config/doom/modules/org-setup.org\n"))

(after! org
  (setq org-latex-image-default-width ".5\\linewidth"))

(provide 'org-mode)
;;; org-mode.el ends here
