(package-initialize)


;; get path that is used from shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)
  )

;; enable flycheck for everything
(add-hook 'after-init-hook #'global-flycheck-mode)

;; company-mode for everyone
(add-hook 'after-init-hook 'global-company-mode)

;; elm stuff

(with-eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup))

(with-eval-after-load 'company-mode
  '(add-to-list 'company-backends 'company-elm))

(defun elm-save-hook ()
  (when (eq major-mode 'elm-mode)
    '((elm-format)
       )))

(add-hook 'after-save-hook #'elm-save-hook)

(setq elm-tags-on-save t)

(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

;; --- elm stuff end

;; --- golang stuff

;;  go-autocomplete and stuff related to go-config
(add-to-list 'load-path "~/.emacs.d/gomacs/")

;; custom flycheck for golang
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup))


;; function to format go-code
(defun go-save-hook ()
  (when (eq major-mode 'go-mode)
    (gofmt)))

;; format go-code on save
(add-hook 'before-save-hook #'go-save-hook)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
    ;;'("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
      '("melpa" . "http://melpa.milkbox.net/packages/")
   t))

(setq package-archives '(
		         ("melpa" . "https://melpa.org/packages/")))

;; add go-imports to gofmt command
(setq gofmt-command "goimports")

(defun my-go-mode-hook()
  (local-set-key (kbd "C-c m") 'gofmt)
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  (local-set-key (kbd "M-.") 'godef-jump))

(add-hook 'go-mode-hook 'my-go-mode-hook)


;; autocomplete for golang
(require 'go-autocomplete)
(require 'auto-complete-config)

(ac-config-default)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (## flycheck-elm company go-mode flycheck-gometalinter flycheck-golangci-lint markdown-mode exec-path-from-shell go-imports go-eldoc elm-mode dockerfile-mode company-go auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
