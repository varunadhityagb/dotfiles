;;; modules/keybinds.el -*- lexical-binding: t; -*-

;; Insert setupfile
(map! :leader
      "b a b i" #'insert-setupfile)

;; Open vterm
(map! :leader
      :desc "Open vterm" "o t" #'vterm)

;; Find file at point
(map! :leader
      :desc "Find file at point" "f o" #'ffap)

;; Reload theme
(map! :leader
      :desc "Reload theme" "h h" #'my/reload-theme)

;; LaTeX clean
(map! :map LaTeX-mode-map
      :localleader
      :desc "Clean LaTeX aux files" "C" #'+latex/clean)

;; Jupyter keybindings
(map! :leader
      (:prefix ("j" . "jupyter")
       :desc "Connect to REPL" "c" #'my/jupyter-connect-repl
       :desc "Insert kernel path" "i" #'my/insert-jupyter-kernel
       :desc "Open QtConsole" "q" #'my/jupyter-qtconsole
       :desc "Cleanup kernels" "k" #'my/jupyter-cleanup-kernels
       :desc "Insert property header" "h" #'jupyter-property-header))

(provide 'keybinds)
;;; keybinds.el ends here
