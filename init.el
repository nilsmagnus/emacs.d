(setq exec-path (append exec-path '("~/go/bin")))

;; if signature-check fails, consider to activate following line:
;;(setq package-check-signature nil)

;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setq inhibit-startup-screen t)
(setq package-list '(lsp-mode lsp-ui elm-mode company-go company-lsp go-mode markdown-mode magit exec-path-from-shell go-imports go-eldoc dockerfile-mode yasnippet exec-path-from-shell multiple-cursors zenburn-theme cider yaml-mode highlight-parentheses))

(require 'package)
(add-to-list
   'package-archives
   ;;'("melpa" . "http://melpa.org/packages/") ; many packages won't show if using stable
   ;;'("melpa" . "http://melpa.milkbox.net/packages/")
   '("marmalade" . "http://marmalade-repo.org/packages/")
   t)

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; backup config, tips from https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
(setq backup-directory-alist `(("." . "~/.saves")))
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)



;; dark theme, zenburn
;; set background-color to green of current variable in golang
(setq zenburn-override-colors-alist
      '(("zenburn-bg-05"  . "#339933")))
(load-theme 'zenburn t)

;; Multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; MAGIT
(global-set-key (kbd "C-x g") 'magit-status)

;; highlight parentheses for all

(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; ELM stuff
;;(require 'elm-mode)
(defun my-elm-mode-hook()
  (setq elm-sort-imports-on-save t)
  (setq elm-tags-exclude-elm-stuff nil)
  (setq elm-tags-on-save t)
  (setq tags-revert-without-query 1)
  )
;; for some insane reason the following line cannot be inside a hook
(setq elm-format-on-save t)
(add-hook 'elm-mode-hook 'my-elm-mode-hook)
(add-hook 'elm-mode-hook #'lsp)
(setq lsp-elm-server-install-dir "/usr/local/bin/elm-language-server")


;; GO - stuff
(require 'yasnippet)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-go/")
(yas-global-mode 1)

; LSP related
(require 'lsp-mode)
(require 'company-lsp)
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'go-mode-hook #'lsp)
(global-set-key (kbd "C-x r") 'lsp-rename)



;;(require 'go-guru)

;; autocompletion stuff
;;(add-to-list 'load-path "~/.emacs.d/autocomplete/")
;;(require 'go-autocomplete)
;;(require 'auto-complete-config)
;;(ac-config-default)

;;(require 'go-repl-mode)

(setq gofmt-command "goimports")


;; function to format go-code
(defun go-save-hook ()
  (when (eq major-mode 'go-mode)
    (gofmt)
    (gofmt)
    ))

;; format go-code on save
(add-hook 'before-save-hook #'go-save-hook)


(defun my-go-mode-hook()
  (local-set-key (kbd "C-c m") 'lsp-format-buffer)
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  (local-set-key (kbd "M-.") 'lsp-find-definition))

(add-hook 'go-mode-hook 'my-go-mode-hook)

;; END GO 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a7051d761a713aaf5b893c90eaba27463c791cd75d7257d3a8e66b0c8c346e77" default)))
 '(lsp-ui-peek-enable t)
 '(package-selected-packages
   (quote
    (yaml-mode zenburn-theme multiple-cursors use-package magit auto-complete-confi auto-complete-config go-autocomplete)))
 '(safe-local-variable-values
   (quote
    ((elm-interactive-command "elm" "repl")
     (elm-reactor-command "elm" "reactor")
     (elm-compile-command "elm" "make")
     (elm-package-command "elm" "package")
     (elm-package-json . "elm.json")
     (elm-compile-arguments "--output=elm.js" "--debug")
     (elm-reactor-arguments "--port" "8000")))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:inherit consolas)))))
