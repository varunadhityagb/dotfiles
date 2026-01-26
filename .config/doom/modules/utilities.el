;;; modules/utilities.el -*- lexical-binding: t; -*-

;; Disable kill emacs confirmation
(setq confirm-kill-emacs nil)

;; Trash instead of delete
(setq delete-by-moving-to-trash t)

;; Uncomment if you want to use a custom splash image
;; (setq fancy-splash-image (concat doom-private-dir "varun.png"))

(defun my/three-pane-layout ()
  "Create a 3-pane vertical window layout and focus center."
  (interactive)
  (delete-other-windows)

  (let* ((total (window-total-width))
         (left-width (floor (* 0.20 total))))
    ;; Left pane
    (split-window-right left-width)

    ;; Split remaining space evenly
    (other-window 1)
    (split-window-right))

  ;; Focus center pane
  (other-window 1))


(provide 'utilities)
;;; utilities.el ends here
