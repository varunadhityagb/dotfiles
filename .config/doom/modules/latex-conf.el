;;; modules/latex.el -*- lexical-binding: t; -*-

;; LaTeX configuration for org-mode
(after! ox-latex
  ;; Use minted for code highlighting
  (setq org-latex-listings 'minted)
  (setq org-latex-packages-alist '(("" "minted")))

  ;; Use XeLaTeX with proper shell escape for minted
  ;; Run 3 times to ensure all references are resolved
  (setq org-latex-pdf-process
        '("xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"
          "xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"
          "xelatex -shell-escape -interaction nonstopmode -output-directory=%o %f"))

  ;; Ensure proper UTF-8 encoding
  (setq org-latex-inputenc-alist '(("utf8" . "utf8x")))

  ;; Better default for XeLaTeX
  (setq org-latex-compiler "xelatex"))

;; LaTeX cleanup function
(defun +latex/clean ()
  "Delete auxiliary LaTeX files in the current directory."
  (interactive)
  (let ((clean-extensions '("aux" "fdb_latexmk" "fls" "log" "out" "synctex.gz"
                            "toc" "bbl" "blg" "nav" "snm" "vrb"))
        (base (file-name-sans-extension (buffer-file-name))))
    (dolist (ext clean-extensions)
      (let ((file (concat base "." ext)))
        (when (file-exists-p file)
          (delete-file file))))
    (when (file-directory-p ".auctex-auto")
      (delete-directory ".auctex-auto" t))
    (when (file-directory-p "_minted-*")
      (delete-directory "_minted-*" t))
    (message "Cleaned up LaTeX auxiliary files.")))

(provide 'latex-conf)
;;; latex-conf.el ends here
