;--------------------;
;;; window frame and size, background color ;;;
;--------------------;
;; Set up frame properties (Window Size)
(add-to-list 'default-frame-alist '(width . 100)) ; character
(add-to-list 'default-frame-alist '(height . 52)) ; lines
;; only change background color if run in graph, do not change for terminal
(when (display-graphic-p)
  (add-to-list 'default-frame-alist '(background-color . "#D6E0EA"))) ; background color
;; (add-to-list 'default-frame-alist '(background-color . "#D6E0EA")) ; background color
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; turn off bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; under the python-mode: 'C-c <' shift block 4 spaces left; '>' for right


;; Enable ido
(require 'ido)
(ido-mode t)

;; Enable IBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 30 30 :left :elide) " "
              (size 9 -1 :right) " "
              (mode 16 16 :left :elide) " " filename-and-process)
        (mark " " (name 16 -1) " " filename)))

;; Set Frame Title
;; more useful frame title that show either a file or a buffer name
(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))


(defalias 'ar 'align-regexp)



;; reverts all buffers that are visiting a file
(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )


;; kill the line to the beginning(M-k can do it by default)
(global-set-key (kbd "M-k") (lambda ()
                                        (interactive)
                                        (kill-line 0)))


;; go back to the previous windows frame appearance C-c LEFT
(when (fboundp 'winner-mode)
(winner-mode)
(windmove-default-keybindings))


;; Highlight lines that exceed certain limit
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode) ;; apply this only to major programming


;--------------------;
;;; User Interface ;;;
;--------------------;

; ignore case when searching
(setq case-fold-search t)

; display line numbers to the right of the window
;; (add-to-list 'load-path "~/.emacs.d/linum")
;; (require 'linum)              ;; needed for an old emacs22 but not for new.
(global-linum-mode t)
; show the current line and column numbers in the stats bar as well
(line-number-mode t)
(column-number-mode t)


; highlight the current line
(add-to-list 'load-path "~/.emacs.d/highlight-current-line-0.57")
(require 'highlight-current-line)
(global-hl-line-mode t)
(setq highlight-current-line-globally t)
(setq highlight-current-line-high-faces nil)
(setq highlight-current-line-whole-line nil)
(setq hl-line-face (quote highlight))

;; Highlight symbols
(add-to-list 'load-path "~/.emacs.d/highlight-symbol")
(require 'highlight-symbol)
;;(highlight-symbol-mode 1)   ;; keep the symbol at point highlighted
;;(highlight-symbol-nav-mode 1) ;; enable key bindings (M-n and M-p) for navigation.

;; ;; use globally
;; (define-globalized-minor-mode my-global-highlight-symbol-mode highlight-symbol-mode
;;   (lambda () (highlight-symbol-mode 1) (highlight-symbol-nav-mode 1)))
;; (my-global-highlight-symbol-mode 1)

;; hook to specific mode (python, c, sh)
(defun my-highlight-symbol-mode-hook ()
  (highlight-symbol-mode 1) (highlight-symbol-nav-mode 1))
(add-hook 'python-mode-hook 'my-highlight-symbol-mode-hook)
(add-hook 'c-mode-hook 'my-highlight-symbol-mode-hook)
(add-hook 'sh-mode-hook 'my-highlight-symbol-mode-hook)

(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)


;--------------------;
;;; Indentation    ;;;
;--------------------;
; always use spaces, not tabs, when indenting
(setq-default indent-tabs-mode nil)
;; set default tab char's display width to 4 spaces
(setq-default tab-width 4) ;
(setq c-default-style "linux"
          c-basic-offset 4)

;--------------------;
;;; Remove trailing whitespace only delete-trailing-whitespace
;--------------------;
(add-hook 'python-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
(add-hook 'c-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))



;; Auto Complete
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.3.1/")
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete-1.3.1//ac-dict")
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 4)  ;; set to trig after 4
(setq ac-auto-show-menu 0.8) ;; show menu 0.8 s later
(global-auto-complete-mode t) ;; apply globally

;;----------------------------------------------------------------------------
;; Use Emacs' built-in TAB completion hooks to trigger AC (Emacs >= 23.2)
;;----------------------------------------------------------------------------
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;; Stop completion-at-point from popping up completion buffers so eagerly
(setq completion-cycle-threshold 5)

(setq c-tab-always-indent nil
      c-insert-tab-function 'indent-for-tab-command)

;; hook AC into completion-at-point
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)


(set-default 'ac-sources
             '(ac-source-imenu
               ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-words-in-all-buffer))

(dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
                sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                html-mode nxml-mode sh-mode smarty-mode clojure-mode
                lisp-mode textile-mode markdown-mode tuareg-mode
                js3-mode css-mode less-css-mode))
  (add-to-list 'ac-modes mode))




;--------------------;
;;; window numbering ;;;
;--------------------;
;; set 'Ibuffer' to 0. use M-num to navigate
(add-to-list 'load-path "~/.emacs.d/window-numbering-1.1.2")
(require 'window-numbering)
(window-numbering-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold))) t))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode nil)
 '(inhibit-startup-screen t))
