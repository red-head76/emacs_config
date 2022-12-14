;; Set garbage collection threshold
;; From https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/

(setq gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold (* 1024 1024 100))

;; Set file-name-handler-alist

;; Also from https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/

(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Set deferred timer to reset them
(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original)
   (setq file-name-handler-alist file-name-handler-alist-original)
   (makunbound 'gc-cons-threshold-original)
   (makunbound 'file-name-handler-alist-original)
   ;;  (message "gc-cons-threshold and file-name-handler-alist restored")
   ))

(defun custom/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'custom/display-startup-time)

(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ;; start in fullscreen

;; Use the bootstrap code to enable straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Use straight as package-manager by default
(use-package straight
           :custom (straight-use-package-by-default t))

(use-package expand-region)

(defun custom-newline-and-indent ()
"Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
(interactive)
(move-end-of-line nil)
(newline-and-indent))

;; Set this globally
(global-set-key (kbd "M-RET") 'custom-newline-and-indent)

(use-package xah-fly-keys
  :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
  :config
  (xah-fly-keys 1)
  (xah-fly-keys-set-layout "qwerty")
  ;; Use home as activation key. Its recomended to rebind CapsLock to home.
  (global-set-key (kbd "<home>") 'xah-fly-command-mode-activate)
  ;; This is only for better readability with the 'where-is'-command
  (when xah-fly-use-control-key
    (global-set-key (kbd "<space>") 'xah-fly-leader-key-map)
    (global-set-key (kbd "<f7>") 'nil))
  ;; Change isearch from arrow keys to Alt-ijkl
  (xah-fly--define-keys
   isearch-mode-map
   '(("M-i" . isearch-ring-retreat)
     ("M-k" . isearch-ring-advance)
     ("M-j" . isearch-repeat-backward)
     ("M-l" . isearch-repeat-forward))
   :direct)
  ;; Make ESC do C-g (xah-lee version)
  (define-key key-translation-map (kbd "ESC") (kbd "C-g"))
  ;; unset leader-c, leader-x
  (define-key xah-fly-leader-key-map (kbd "x") 'nil)
  (define-key xah-fly-leader-key-map (kbd "c") 'nil)
  ;; replace xah-comment-dwim with the original one
  (define-key xah-fly-insert-map [remap xah-comment-dwim] 'comment-dwim)
  ;; better scrolling
  (define-key xah-fly-command-map (kbd "9") 'scroll-down-line)
  (define-key xah-fly-command-map (kbd "0") 'scroll-up-line)
  ;; Delete char normally
  (define-key xah-fly-command-map (kbd "d") 'delete-backward-char)
  (define-key xah-fly-command-map (kbd "g") 'delete-char)
  ;; expand region
  (define-key xah-fly-command-map [remap xah-extend-selection] 'er/expand-region)
  (define-key xah-fly-command-map (kbd "<f9>") 'er/contract-region)
  ;; fill-paragraph instead of reformat-line
  (define-key xah-fly-command-map [remap xah-reformat-lines] 'fill-paragraph)
  ;; Join line. Alternative is shrink-whitespace ('w' on command map)
  (define-key xah-fly-leader-key-map (kbd "j") 'join-line)
  ;; switch window split below and right
  (define-key xah-fly-command-map (kbd "4") 'split-window-right)
  (define-key xah-fly-leader-key-map (kbd "4") 'split-window-below)
  ;; Switch lines
  (define-key xah-fly-insert-map (kbd "s-i") 'elpy-nav-move-line-or-region-up)
  (define-key xah-fly-insert-map (kbd "s-k") 'elpy-nav-move-line-or-region-down)
  (define-key xah-fly-insert-map (kbd "s-j") 'elpy-nav-indent-shift-left)
  (define-key xah-fly-insert-map (kbd "s-l") 'elpy-nav-indent-shift-right)
  ;; go to next/previous punct
  (define-key xah-fly-command-map (kbd "[") 'xah-backward-punct)
  (define-key xah-fly-command-map (kbd "]") 'xah-forward-punct)

  ;; insert latex math bracket
  (defun xah-insert-LaTeX-math-bracket () (interactive) (xah-insert-bracket-pair "\\(" "\\)"))
  (define-key xah-fly-leader-key-map (kbd "d m") 'xah-insert-LaTeX-math-bracket)
  )

  ;; Newline AND indent
  (define-key global-map [remap newline]  'newline-and-indent)

;; When selecting a region and typing something, the region should be deleted/replaced
(delete-selection-mode t)
;; Fill column to 99 (from 70 default)
(setq-default fill-column 99)

;; Previous/next terminal command in python-terminal
;; TODO: build hook for python inferior mode
;; (define-key xah-fly-insert-map (kbd "M-i") 'comint-previous-input)
;; (define-key xah-fly-insert-map (kbd "M-k") 'comint-next-input)

;; Isearch ignore linebreaks, tabs etc.
(setq search-whitespace-regexp "[ \t\r\n]+")

;; smartparens-predefinitions
(defun def-sp-keybindings ()
  ;; define keymap
  (define-prefix-command 'sp-keymap)
  (define-key xah-fly-leader-key-map (kbd "x") sp-keymap)
  ;; define keys
  (define-key sp-keymap (kbd "r") 'sp-rewrap-sexp)
  (define-key sp-keymap (kbd "j") 'sp-beginning-of-sexp)
  (define-key sp-keymap (kbd "l") 'sp-end-of-sexp)
  (define-key sp-keymap (kbd "k") 'sp-down-sexp)
  (define-key sp-keymap (kbd "i") 'sp-backward-up-sexp)
  (define-key sp-keymap (kbd "u") 'sp-backward-down-sexp)
  (define-key sp-keymap (kbd "o") 'sp-up-sexp)
  (define-key sp-keymap (kbd "h") 'sp-forward-sexp)
  (define-key sp-keymap (kbd ";") 'sp-backward-sexp)
  )

(use-package smartparens
:config
;; (setq sp-autoskip-closing-pair 'always)
;; (setq sp-hybrid-kill-entire-symbol nil)
(smartparens-global-mode 1)
(def-sp-keybindings)
(setq sp-navigate-reindent-after-up-in-string nil)

;; disable ' in lisp-modes
(sp-with-modes sp-lisp-modes
  (sp-local-pair "'" nil :actions nil))
)

(defalias 'yes-or-no-p 'y-or-n-p)	;just type for 'y' or 'n' instead of 'yes' and 'no'
(setq inhibit-startup-message t)	; Disable startup-message
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(column-number-mode)			; Display column number
(global-display-line-numbers-mode t)	; Display line number

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :weight 'regular)

;; Set default font
(set-face-attribute 'default nil :font "Fira Code Retina")

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina")

;; Enable fira-code ligatures (combines multiple chars into one visible)
(use-package fira-code-mode
  ;; ligatures you don't want
  :custom (fira-code-mode-disabled-ligatures '("[]" "x"))
  ;; mode to enable fira-code-mode in prog-mode
  :hook prog-mode)

(use-package doom-themes
  :init (load-theme 'doom-moonlight t))

(use-package rainbow-delimiters
  :hook 
  (prog-mode . rainbow-delimiters-mode)
  (LaTeX-mode . rainbow-delimiters-mode)
  :config (set-face-attribute 'rainbow-delimiters-depth-3-face nil :foreground "yellow"))

(defun highlight-cursor-on () (set-cursor-color "orange"))
(defun highlight-cursor-off () (set-cursor-color "#82aaff"))

(add-hook 'xah-fly-command-mode-activate-hook 'highlight-cursor-on)
(add-hook 'xah-fly-insert-mode-activate-hook  'highlight-cursor-off)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 15)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-buffer-encoding nil)
  (set-face-attribute 'doom-modeline-evil-normal-state nil :foreground "orange")
  (setq doom-modeline-env-version nil)
  (setq doom-modeline-buffer-file-name-style 'buffer-name))

(use-package which-key
  :diminish which-key-mode		; don't show it in modeline
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))	; appear after 1 sec

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1)
  ;; Disable M-x starting with '^'
  (ivy-configure 'counsel-M-x
    :initial-input ""))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;(prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package highlight-indentation
  :hook prog-mode
  :config
  (set-face-background 'highlight-indentation-face "#292C44")
  )

(defadvice kill-buffer (around kill-buffer-around-advice activate)
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*scratch*")
        (bury-buffer)
      ad-do-it)))

(defun custom/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end1)"???"))))))
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)
  ; LaTeX font size
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5)))

(defun org-cycle-current-headline ()
  (interactive)
  (outline-previous-heading)
  (org-cycle))

(defun custom/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  )

(use-package org
  ;; :straight (:type built-in)
  :commands (org-capture org-agenda)
  :hook (org-mode . custom/org-mode-setup)
  :custom (org-ellipsis " ???")
  :config
  (custom/org-font-setup)
  (define-key org-mode-map (kbd "C-c t") 'org-cycle-current-headline)
  )

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("???" "???" "???" "???" "???" "???" "???")))

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

;; Automatically tangle our Emacs.org config file when we save it
(defun custom/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'custom/org-babel-tangle-config)))

(setq browse-url-browser-function #'browse-url-firefox)

(use-package dired
  :straight (:type built-in)
  :commands (dired dired-jump)
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :bind (:map dired-mode-map
	      ("W" . wdired-change-to-wdired-mode)))

;; Prevents dired from opening mutliple dired buffers, but only one
(use-package dired-single
  :commands (dired dired-jump))

;; Use fancy icons also in dired
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering
;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
:config
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
      )

(use-package yasnippet
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1024 1024))

(use-package flycheck
  :hook prog-mode
  :init (global-flycheck-mode)
  :custom
  (flycheck-flake8-maximum-line-length 100)
  )

;; Use doctest functionality
(defun elpy-doctest-buffer (&optional arg)
  "Send the active buffer to the Python shell and run any doctests.
        With the prefix argument it will run the doctest in verbose mode"
  (interactive "P")
  (python-shell-send-buffer)
  (python-shell-send-string "import doctest")
  (if arg
      (python-shell-send-string "doctest.testmod(verbose=True)")
    (python-shell-send-string "doctest.testmod(verbose=False)")))

;; elpy-predefinitions
(defun def-elpy-keybindings ()
  ;; elpy-keymap
  (define-key xah-fly-leader-key-map (kbd "c") 'nil)
  ;; define keys
  (define-key xah-fly-leader-key-map (kbd "c f") 'elpy-folding-toggle-at-point)
  (define-key xah-fly-leader-key-map (kbd "c m") 'python-mark-defun)
  (define-key xah-fly-leader-key-map (kbd "c k") 'elpy-shell-kill)
  (define-key xah-fly-leader-key-map (kbd "c c") 'elpy-shell-send-region-or-buffer)
  (define-key xah-fly-leader-key-map (kbd "c t") 'elpy-doctest-buffer)
  )

;;  Using elpy as development environment
(use-package elpy
  :init
  (elpy-enable)
  :hook
  (elpy-mode . def-elpy-keybindings)
  (elpy-mode . hs-minor-mode)
  (elpy-mode . flyspell-prog-mode)
  (elpy-mode . (lambda () (set-fill-column 99)))
  (elpy-mode . flycheck-mode)
  :custom
  (elpy-rpc-python-command "python3")  ; use python3
  (python-shell-interpreter "python3") ; use python3
  (elpy-code-formatter 'autopep8)
  (elpy-shell-starting-directory 'current-directory) ;; default is 'project-root
  (elpy-shell-echo-input nil)
  (python-shell-completion-native-enable nil)
  :config
  ;; elpy uses flymake by default, I want to use flycheck instead
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  ;; enable folding module
  ;; (add-to-list 'elpy-modules 'elpy-modules-folding)
  ;; (setq elpy-modules (append elpy-modules 'elpy-module-folding nil))
  ;; activate virtual environment
  (with-eval-after-load 'elpy (pyvenv-activate "~/.emacs.d/elpy/rpc-venv"))
  ;; Use smartparens python config
  ;; (require 'smartparens-python)
  )

(use-package py-autopep8
  :hook (python-mode . py-autopep8-enable-on-save)
  :custom
  (py-autopep8-options '("--max-line-length=100" "--aggressive"))
  )

;; (define-key python-mode-map (kbd "M->") 'elpy-nav-indent-shift-right)
;; (define-key python-mode-map (kbd "M-<") 'elpy-nav-indent-shift-left)

(defun def-LaTeX-keybindings ()
  ;; define keymap
  (define-prefix-command 'LaTeX-keymap)
  (define-key xah-fly-leader-key-map (kbd "c") LaTeX-keymap)
  ;; define keys
  (define-key LaTeX-keymap (kbd "q") 'LaTeX-fill-paragraph)
  (define-key LaTeX-keymap (kbd "c") 'TeX-command-master)
  (define-key LaTeX-keymap (kbd "v") 'TeX-view)
  (define-key LaTeX-keymap (kbd "s") 'LaTeX-section)
  (define-key LaTeX-keymap (kbd "e") 'LaTeX-environment)
  (define-key LaTeX-keymap (kbd ".") 'LaTeX-mark-environment)
  (define-key LaTeX-keymap (kbd "j") 'LaTeX-insert-item)
  (define-key LaTeX-keymap (kbd "r") 'reftex-hyperref-autoref)
  (define-key LaTeX-keymap (kbd "p") 'reftex-citep)
  (define-key LaTeX-keymap (kbd "t") 'reftex-toc)
  ;; Unset insert-quote because it destroys smartparens work
  ;; (define-key TeX-mode-map (kbd "\"") nil)
  )

;; (use-package tikz
;; :config
;; (setq tikz-viewer "PDF Tools"))

;; maybe the following could be updated with the init from
;; https://github.com/jwiegley/use-package/issues/379

(use-package tex-mode 			; auctex
  :hook
  (LaTeX-mode . def-LaTeX-keybindings)
  (LaTeX-mode . company-mode)
  (LaTeX-mode . flyspell-mode)
  ;; Use orgtbl-mode for creating tables
  ;; (LaTeX-mode . orgtbl-mode)
  :mode "\\.tex\\'"
  :config
  (add-hook 'LaTeX-mode-hook 'flyspell-buffer)
  (add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
  (add-hook 'LaTeX-mode-hook (lambda () (set-fill-column 99)))
  ;; (load "auctex.el" nil t t)
  (setq TeX-parse-self t)
  (setq TeX-save-query nil)
  (setq TeX-master "./main")
  (setq TeX-PDF-mode t)
  ;; Use smartparens config for latex
  (require 'smartparens-latex)
  ;; Use pdf-tools to open PDF files
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")) TeX-source-correlate-start-server t)
  ;; Revert pdf buffer after compiling document
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  ;; Reftex things
  (require 'reftex)
  (add-hook 'LaTeX-mode-hook 'reftex-parse-all)
  (setq reftex-plug-into-AUCTeX t)
  (add-to-list 'reftex-default-bibliography "../inputs/references.bib")
  (add-to-list 'reftex-default-bibliography "references.bib")
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  ;; ('(setcar (cdr (assoc 'output-pdf TeX-view-program-selection)) "Okular"))
  )

;; (use-package ess
;;  :mode ("\\.r\\'" . r-mode))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))


(use-package company-auctex
  :hook LaTeX
  :config
  (company-auctex-init))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package pdf-tools
:mode ("\\.pdf\\'" . pdf-view-mode)
:config
(pdf-tools-install t)
(setq pdf-view-midnight-minor-mode t)
)
