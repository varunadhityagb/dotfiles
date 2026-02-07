;;; modules/jupyter.el -*- lexical-binding: t; -*-
;;; Jupyter notebook integration for Emacs org-mode

;; LSP for Python
(use-package lsp-pyright
  :defer t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (unless (eq major-mode 'snakemake-mode)
                           (lsp)))))

;; Auto-detect and activate venv in project directory
(defun my/find-venv-directory ()
  "Find .venv directory in current directory or project root."
  (let* ((current-dir default-directory)
         (project-root (and (fboundp 'projectile-project-root)
                            (projectile-project-root)))
         (venv-current (expand-file-name ".venv" current-dir))
         (venv-project (when project-root
                         (expand-file-name ".venv" project-root))))
    (cond
     ((file-directory-p venv-current) venv-current)
     ((and venv-project (file-directory-p venv-project)) venv-project)
     (t nil))))

(defun my/auto-activate-venv ()
  "Automatically activate Python venv if .venv found."
  (when-let ((venv-path (my/find-venv-directory)))
    (pyvenv-activate venv-path)
    (message "Activated venv: %s" venv-path)
    ;; Restart LSP if it's running
    (when (bound-and-true-p lsp-mode)
      (lsp-restart-workspace))))

(add-hook 'python-mode-hook #'my/auto-activate-venv)
(add-hook 'org-mode-hook #'my/auto-activate-venv)

;; Jupyter - Load FIRST
(use-package jupyter
  :commands (jupyter-run-server-repl
             jupyter-run-repl
             jupyter-connect-repl)
  :config
  ;; Use ipython from .venv if available
  (defun my/jupyter-use-venv-python ()
    "Set jupyter to use ipython from .venv if it exists."
    (when-let ((venv-path (my/find-venv-directory)))
      (let ((ipython-path (expand-file-name "bin/ipython" venv-path)))
        (when (file-executable-p ipython-path)
          (setq-local jupyter-runtime-directory 
                      (expand-file-name "share/jupyter/runtime" venv-path))
          (message "Using ipython from: %s" ipython-path)))))
  
  (add-hook 'jupyter-repl-mode-hook #'my/jupyter-use-venv-python))

;; Code cells for notebook-like experience
(use-package code-cells
  :config
  (setq code-cells-convert-ipynb-style
        '(("pandoc" "--to" "ipynb" "--from" "org")
          ("pandoc" "--to" "org" "--from" "ipynb")
          org-mode)))

;; Org-mode Jupyter configuration - Load AFTER jupyter
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

  ;; Make sure jupyter-python blocks open in python-mode
  (setq org-src-lang-modes '(("jupyter-python" . python)
                             ("python" . python)))

  ;; Enable LSP in Python source block edit buffers
  (defun my/org-babel-edit-prep:python (info)
    "Enable LSP in Python source block edit buffers."
    (setq-local buffer-file-name (concat default-directory "org-src-babel.py"))
    (setq-local org-element-use-cache nil)
    (lsp-deferred))

  (add-hook 'org-src-mode-hook
            (lambda ()
              (when (eq major-mode 'python-mode)
                (my/org-babel-edit-prep:python nil))))

  :hook
  (org-babel-after-execute . org-display-inline-images))

;;; Helper functions for Jupyter kernel management

(defun my/get-jupyter-runtime-folder ()
  "Get Jupyter runtime folder."
  (let ((runtime-dir (string-trim
                      (shell-command-to-string
                       (if-let ((venv-path (my/find-venv-directory)))
                           (format "%s/bin/jupyter --runtime-dir" venv-path)
                         "jupyter --runtime-dir")))))
    (if (string-empty-p runtime-dir)
        (expand-file-name "~/.local/share/jupyter/runtime")
      runtime-dir)))

(defun my/get-open-ports ()
  "Get list of open ports on the system."
  (mapcar
   #'string-to-number
   (split-string (shell-command-to-string "ss -tulpnH | awk '{print $5}' | sed -e 's/.*://'") "\n")))

(defun my/list-jupyter-kernel-files ()
  "List Jupyter kernel files with their ports."
  (let ((runtime-folder (my/get-jupyter-runtime-folder)))
    (when (file-directory-p runtime-folder)
      (mapcar
       (lambda (file)
         (cons (car file)
               (cdr (assq 'shell_port (json-read-file (car file))))))
       (sort
        (directory-files-and-attributes runtime-folder t ".*kernel.*json$")
        (lambda (x y) (not (time-less-p (nth 6 x) (nth 6 y)))))))))

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
  (let ((kernel-file (my/select-jupyter-kernel))
        (session-name (read-string "Session name (for org-mode): " "main")))
    (jupyter-connect-repl kernel-file nil nil nil t session-name)))

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
    (insert (format "\n#+PROPERTY: header-args:jupyter-python :session %s :kernel %s :eval never-export :results output :exports both\n"
                    session-name kernel-name))))

(provide 'jupyter)
;;; jupyter.el ends here
