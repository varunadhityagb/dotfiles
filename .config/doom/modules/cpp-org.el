;;; cpp-org.el -*- lexical-binding: t; -*-

;; LSP for C++
(use-package lsp-mode
  :defer t
  :hook (c++-mode . lsp)
  :commands lsp)

;; Add C++ to org-babel languages
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     (C . t)  ; This enables both C and C++
     (jupyter . t)))

  ;; Make 'cpp' open in c++-mode when editing (for SPC m ')
  (add-to-list 'org-src-lang-modes '("cpp" . c++))

  ;; Make babel treat 'cpp' as 'C' for execution
  (defalias 'org-babel-execute:cpp 'org-babel-execute:C)
  (defalias 'org-babel-expand-body:cpp 'org-babel-expand-body:C)

  ;; Add template for C++ blocks
  (add-to-list 'org-structure-template-alist '("cpp" . "src c++ :results output"))

  ;; Enable LSP in C++ source block edit buffers
  (defun my/org-babel-edit-prep:c++ (info)
    "Enable LSP in C++ source block edit buffers."
    (setq-local buffer-file-name (concat default-directory "org-src-babel.cpp"))
    (lsp-deferred))

  ;; Hook to activate LSP when editing C++ blocks
  (add-hook 'org-src-mode-hook
            (lambda ()
              (when (eq major-mode 'c++-mode)
                (my/org-babel-edit-prep:c++ nil)))))

(provide 'cpp-org)
;;; cpp-org.el ends here
