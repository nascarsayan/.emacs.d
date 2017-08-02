;;; package --- Summary
;;; Commentary:
;;; Code:

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/custom")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/monokai")
(load-theme 'monokai t)

(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(defalias 'yes-or-no-p 'y-or-n-p) ;;; yes --> y ; no --> n

(setq helm-gtags-prefix-key "\C-cg")

(require 'setup-helm)
(require 'setup-helm-gtags)
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(windmove-default-keybindings)

(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET

(global-set-key (kbd "C-c w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

(setq-default tab-width 2)

(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

(require 'dtrt-indent)
(dtrt-indent-mode 1)

(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

(require 'yasnippet)
(yas-global-mode 1)

(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)

;; Package zygospore
;;(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)
(require 'auto-complete-config)
(ac-config-default)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x C-;") 'uncomment-region)
(global-linum-mode t)
(setq case-fold-search t)
(setq require-final-newline t)
(setq truncate-lines t)
(setq truncate-partial-width-windows t)
(line-number-mode t)
(column-number-mode t)
(require 'font-lock)
(setq font-lock-maximum-decoration t)
(global-font-lock-mode t)
(global-hi-lock-mode nil)
(setq jit-lock-contextually t)
(setq jit-lock-stealth-verbose t)
(defun djcb-opacity-modify (&optional dec)
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
         (oldalpha (if alpha-or-nil alpha-or-nil 100))
         (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify))) ;; increase opacity
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t))) ;; decrease opacity
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(define-key c-mode-map  (kbd "<backtab>") 'company-complete)
(define-key c++-mode-map  (kbd "<backtab>") 'company-complete)
(add-to-list 'company-backends 'company-c-headers)

(add-hook 'c-mode-common-hook 'hs-minor-mode)

(setq c-default-style "gnu") ;; set style to "gnu"
(global-flycheck-mode)
(require 'compile)
(add-hook 'c-mode-hook
          (lambda ()
            (unless (file-exists-p "Makefile")
              (set (make-local-variable 'compile-command)
                   ;; emulate make's .c.o implicit pattern rule, but with
                   ;; different defaults for the CC, CPPFLAGS, and CFLAGS
                   ;; variables:
                   ;; $(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<
                   (let ((file (file-name-nondirectory buffer-file-name)))
                     (format "%s -o %s %s %s %s -lm"
                             (or (getenv "CC") "gcc")
                             (file-name-sans-extension file)
                             (or (getenv "CPPFLAGS") "-DDEBUG=9")
                             (or (getenv "CFLAGS") "-ansi -pedantic -Wall -g")
                             file))))))
(require 'cc-mode)
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/Applications/Xcode.app/Contents/Developer/usr/llvm-gcc-4.2/lib/gcc/i686-apple-darwin11/4.2.1/include"))
(defun my:add-semantic-to-autocomplete()
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
;; setup GDB
(setq
 gdb-many-windows t
 gdb-show-main t)

(provide 'init)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (bison-mode zygospore ws-butler volatile-highlights undo-tree tinysegmenter solarized-theme smartparens org neotree key-chord jdee java-snippets java-imports iedit helm-swoop helm-projectile helm-gtags google-c-style ggtags flymake-google-cpplint flymake-cursor flycheck-irony duplicate-thing dtrt-indent darkokai-theme company-c-headers comment-dwim-2 color-theme-solarized color-theme-sanityinc-solarized clean-aindent-mode auto-complete-sage auto-complete-rst auto-complete-pcmp auto-complete-nxml auto-complete-exuberant-ctags auto-complete-clang-async auto-complete-clang auto-complete-chunk auto-complete-c-headers auto-complete-auctex auto-compile auto-auto-indent aurora-theme anzu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
