;;; modules/latex.el -*- lexical-binding: t; -*-

;; LaTeX configuration for org-mode
(setq org-latex-listings 'minted)
(setq org-latex-packages-alist '(("" "minted")))
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"))

;; LaTeX cleanup function
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

(provide 'latex-conf)
;;; latex-conf.el ends here
