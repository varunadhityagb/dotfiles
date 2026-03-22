;;; modules/gpt-el.el -*- lexical-binding: t; -*-

(use-package! gptel
  :config
  (setq gptel-default-mode 'org-mode)
  (setq gptel-backends nil)
  (add-to-list 'gptel-backends
               (gptel-make-ollama "ollama"
                 :host "100.70.52.122:11434"
                 :stream t
                 :models '(gpt-oss:120b-cloud gpt-oss:20b-cloud glm-5:cloud
                           qwen3.5:397b-cloud qwen3-coder:480b-cloud
                           qwen2.5-coder:1.5b llama3.2:latest))))
;;; gpt-el.el ends here
