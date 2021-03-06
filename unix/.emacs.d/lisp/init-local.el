;; init-local.el --- Emacs Initialization File
;;; Commentary:
;; Vim: set ft=lisp: set lisp:

;; Your personal configs

;;; Code:

;; BASIC CUSTOMIZATION
;; --------------------------------------


;; Don't close if i haven't saved customizations
(add-hook 'kill-emacs-query-functions
          'custom-prompt-customize-unsaved-options)

;; Run the Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

;; (setq 'suggest-key-bindings 10) ;; show equivalent keybindings for 10sec. default is 2 but i'm slow
;; apparently i'm doing something wrong. *shrugs*

;; Evil
;;------
(require 'goto-chg)

(setq evil-want-keybinding nil)  ;; because evil-collection said so:q
(setq evil-want-integration t)
(setq evil-want-minibuffer t)
(setq evil-ex-complete-emacs-commands t)

(require 'evil)
(evil-mode t)

(add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-ex-complete-emacs-commands t)

;; Evil requires undo-tree. Don't know where i declare that.
(require 'undo-tree)
;; (setq undo-tree-auto-save-history)

(require 'evil-tabs)
(global-evil-tabs-mode t) ; tabs (requires evil-tabs)

setq (
      evil-emacs-state-cursor '("red" box)
      evil-normal-state-cursor '("green" box)
      evil-visual-state-cursor '("orange" box)
      evil-insert-state-cursor '("red" bar)
      evil-replace-state-cursor '("red" bar)
      evil-operator-state-cursor '("red" hollow))

;; (setq evil-normal-state-modes (append evil-motion-state-modes evil-normal-state-modes))
(setq evil-motion-state-modes nil)

(evil-define-key 'normal 'dired-mode-map
                 "h" 'dired-up-directory
                 "j" 'dired-next-line
                 "k" 'dired-previous-line
                 "l" 'dired-find-alternate-file)

(require 'goto-chg)
(global-set-key [(control ?.)] 'goto-last-change) (global-set-key [(control ?,)] 'goto-last-change-reverse)

(require 'evil-collection)

(when (require 'evil-collection nil t)
  (evil-collection-init))

(setq evil-collection-setup-minibuffer t)  ; vim keybindings even in minibuffers

(setq evil-magit-state 'motion)
;; do i need an evil-magit init func call
(require 'evil-magit)

(global-evil-leader-mode t)
(global-evil-tabs-mode t)

(setq evil-shift-width 4)

;; PYTHON CONFIGURATION
;; --------------------------------------

;; Python

(require 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-mode)

(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i")

(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)

;; Org
;; -----

(require 'org-evil)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

(setq org-indent-indentation-per-level 2)

                                        ; (setq 'org-startup-indented t)

;; (setq 'org-catch-invisible edits t)
;; Hint: This is the main list in lisp/init-git.el
                                        ; (when (maybe-require-package 'magit)
                                        ;   (setq-default magit-diff-refine-hunk t)

                                        ;   ;; Hint: customize `magit-repository-directories' so that you can use C-u M-F12 to
                                        ;   ;; quickly open magit on any one of your projects.
                                        ;   (global-set-key [(meta f12)] 'magit-status)
                                        ;   (global-set-key (kbd "C-x g") 'magit-status)
                                        ;   (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

                                        ;   (defun sanityinc/magit-or-vc-log-file (&optional prompt)
                                        ;     (interactive "P")
                                        ;     (if (and (buffer-file-name)
                                        ;              (eq 'Git (vc-backend (buffer-file-name))))
                                        ;         (if prompt
                                        ;             (magit-log-buffer-file-popup)
                                        ;           (magit-log-buffer-file t))
                                        ;       (vc-print-log)))

                                        ;   (after-load 'vc
                                        ;     (define-key vc-prefix-map (kbd "l") 'sanityinc/magit-or-vc-log-file)))

;; Viper
;; ------

(setq viper-inhibit-startup-message 't)
(setq viper-expert-level '1)


(provide 'init-local)
;; init-local.el ends here
