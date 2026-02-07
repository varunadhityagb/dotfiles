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

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

;; Root of your Maildir
(setq mu4e-maildir "~/Mail/gmail")

(setq user-mail-address "varunadhitya.balaji@gmail.com")

;; Map Gmail special folders exactly as they appear
(setq mu4e-sent-folder   "/[Gmail]/Sent Mail"
      mu4e-drafts-folder "/[Gmail]/Drafts"
      mu4e-trash-folder  "/[Gmail]/Trash"
      mu4e-refile-folder "/[Gmail]/All Mail")

;; Fetch mail with mbsync and update every 5 minutes
(setq mu4e-get-mail-command "mbsync -a"
      mu4e-update-interval 300)

;; Optional: show all headers sorted by date
(setq mu4e-headers-sort-direction 'descending)


;; THE BEST YANK PATH
(defun my/yank-file-uri ()
  "Copy file URI(s) to clipboard using wl-copy."
  (interactive)
  (let* ((files (if (derived-mode-p 'dired-mode)
                    (dired-get-marked-files)
                  (list (buffer-file-name))))
         (uris (mapconcat (lambda (f)
                            (concat "file://" (expand-file-name f)))
                          files
                          "\n")))
    (when uris
      (with-temp-buffer
        (insert uris)
        (call-process-region (point-min) (point-max)
                             "wl-copy" nil nil nil
                             "--type" "text/uri-list"))
      (message "Copied %d file URI(s)" (length files)))))

;; Bind to SPC y (leader key)
(map! :leader
      :desc "Yank file URI" "y" #'my/yank-file-uri)

(provide 'utilities)
;;; utilities.el ends here
