;;; jupyter-notebook-org-mode

;; LSP for Python
(use-package lsp-pyright
  :defer t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (unless (eq major-mode 'snakemake-mode)
                           (lsp))))
  :config
  (add-hook 'conda-postactivate-hook (lambda () (lsp-restart-workspace)))
  (add-hook 'conda-postdeactivate-hook (lambda () (lsp-restart-workspace))))

;;; jupyter - Load FIRST
(use-package jupyter
  :commands (jupyter-run-server-repl
             jupyter-run-repl
             jupyter-connect-repl))

;;; code cells
(use-package code-cells
  :config
  (setq code-cells-convert-ipynb-style
        '(("pandoc" "--to" "ipynb" "--from" "org")
          ("pandoc" "--to" "org" "--from" "ipynb")
          org-mode)))

;;; org-mode configuration - Load AFTER jupyter
(use-package org
  :defer t
  :config
  ;; Don't confirm code block evaluation
  (setq org-confirm-babel-evaluate nil)

  ;; Load babel languages (jupyter must be loaded first)
  (with-eval-after-load 'jupyter
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)
       (shell . t)
       (jupyter . t))))

  ;; Add template for jupyter-python blocks
  (add-to-list 'org-structure-template-alist '("py" . "src jupyter-python"))

  :hook
  (org-babel-after-execute . org-display-inline-images))

;;; Helper functions for Jupyter kernel management
(defun my/get-open-ports ()
  "Get list of open ports on the system."
  (mapcar
   #'string-to-number
   (split-string (shell-command-to-string "ss -tulpnH | awk '{print $5}' | sed -e 's/.*://'") "\n")))

(setq my/jupyter-runtime-folder (expand-file-name "~/.local/share/jupyter/runtime"))

(defun my/list-jupyter-kernel-files ()
  "List Jupyter kernel files with their ports."
  (mapcar
   (lambda (file)
     (cons (car file)
           (cdr (assq 'shell_port (json-read-file (car file))))))
   (sort
    (directory-files-and-attributes my/jupyter-runtime-folder t ".*kernel.*json$")
    (lambda (x y) (not (time-less-p (nth 6 x) (nth 6 y)))))))

(defun my/select-jupyter-kernel ()
  "Select an active Jupyter kernel from running kernels."
  (let ((ports (my/get-open-ports))
        (files (my/list-jupyter-kernel-files)))
    (completing-read
     "Jupyter kernels: "
     (seq-filter
      (lambda (file)
        (member (cdr file) ports))
      files))))

(defun my/insert-jupyter-kernel ()
  "Insert a path to an active Jupyter kernel into the buffer."
  (interactive)
  (insert (my/select-jupyter-kernel)))

(defun my/jupyter-connect-repl ()
  "Open emacs-jupyter REPL, connected to a Jupyter kernel."
  (interactive)
  (jupyter-connect-repl (my/select-jupyter-kernel) nil nil nil t))

(defun my/jupyter-qtconsole ()
  "Open Jupyter QtConsole, connected to a Jupyter kernel."
  (interactive)
  (start-process "jupyter-qtconsole" nil "setsid" "jupyter" "qtconsole" "--existing"
                 (file-name-nondirectory (my/select-jupyter-kernel))))

(defun my/jupyter-cleanup-kernels ()
  "Clean up stale Jupyter kernel files."
  (interactive)
  (let* ((ports (my/get-open-ports))
         (files (my/list-jupyter-kernel-files))
         (to-delete (seq-filter
                     (lambda (file)
                       (not (member (cdr file) ports)))
                     files)))
    (when (and (length> to-delete 0)
               (y-or-n-p (format "Delete %d files?" (length to-delete))))
      (dolist (file to-delete)
        (delete-file (car file))))))

(defun jupyter-property-header ()
  "Insert a Jupyter source block with session and kernel properties."
  (interactive)
  (let* ((session-name (read-string "Session name: "))
         (kernel-name (read-string "Kernel name: ")))
    (insert (format "\n#+PROPERTY: header-args:jupyter-python :session %s :kernel %s\n"
                    session-name kernel-name))))
