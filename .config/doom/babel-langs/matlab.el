;;my custom matlab config

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (matlab . t)
   )
 )


(defun insert-matlab-babel-block()
  "Insert a MATLAB source block"
  (interactive)
  (let* ((current-file (buffer-file-name))
         (tangle-file (concat (file-name-sans-extension current-file) ".m")))
    (insert (format "#+BEGIN_SRC matlab :session *MATLAB* :results output :tangle %s :comments org :async\n"
                    tangle-file))
    (insert "#+END_SRC\n")))


(defun insert-matlab-babel-block-image ()
  "Insert a MATLAB source block with image support"
  (interactive)
  (let* ((output-file (read-string "Output file (e.g., plot.png): "))
         (current-file (buffer-file-name))
         (tangle-file (concat (file-name-sans-extension current-file) ".m")))
    (insert (format "#+BEGIN_SRC matlab :session *MATLAB* :results graphics file :file ./%s.png :tangle %s :comments org :async\n "
                    output-file tangle-file))
    (insert "#+END_SRC\n")))


;;KEY BINDINGS

(map! :leader
      :desc "Matlab"
      "b a b m"  nil
      
      :desc "Insert MATLAB Babel block"
      "b a b m n" #'insert-matlab-babel-block

      :desc "Insert MATLAB Babel image"
      "b a b m i" #'insert-matlab-babel-block-image)
