;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; place your private configuration here

;; -- Theme ---------------------------------------------------------------------
(setq doom-theme 'doom-horizon)

;; fonts
(setq doom-font (font-spec :family "M+ 2m" :size 14 :style "Regular"))
(setq doom-big-font (font-spec :family "M+ 2m" :size 18 :style "Regular"))
(setq doom-variable-pitch-font (font-spec :family "M+ 1c" :size 14 ))

;; modeline
(setq doom-modeline-buffer-encoding nil)
(setq doom-modeline-major-mode-icon nil)
(setq doom-modeline-height 40)
(setq find-file-visit-truename t)
(setq doom-modeline-project-detection 'ffip)

;; prompts
(setq which-key-idle-delay 0.5)


;; -- Basic settings ------------------------------------------------------------
(setq-default
  delete-by-moving-to-trash  t
  uniquify-buffer-name-style 'forward
  window-combination-resize  t
  )

(setq evil-want-fine-undo t
      truncate-string-ellipsis "…"
      display-line-numbers-type 'relative)

(delete-selection-mode 1)

;; slightly nicer default buffer names
(setq doom-fallback-buffer-name "   Doom   "
      +doom-dashboard-name "   Doom   ")


;; -- haskell -------------------------------------------------------------------
(after! haskell
  (setq haskell-process-type 'cabal-new-repl))


;; -- Org -----------------------------------------------------------------------
(add-hook! 'org-mode-hook
  (set-fill-column 2000)
  (+word-wrap-mode t)
  (writeroom-mode t)
  (writegood-mode t)
  (mixed-pitch-mode 1))
(add-hook! 'org-mode-hook #'doom-disable-line-numbers-h)
(after! org
  (add-to-list 'org-modules 'org-habit t)
  (setq jupyter-eval-uses-overlays t)
  (setq org-babel-default-header-args '((:session . "none")
                                        (:results . "replace")
                                        (:exports . "code")
                                        (:cache . "no")
                                        (:noweb . "no")
                                        (:hlines . "no")
                                        (:tangle . "no")
                                        (:comments . "link")))
  (setq global-org-pretty-table-mode t))

;; all the time org settings?
(setq org-directory "~/.org/"
      org-agenda-files (list org-directory)
      org-ellipsis "  "
      org-hide-emphasis-markers t
      org-bullets-bullet-list '(""))


;; -- Python --------------------------------------------------------------------
(after! python
  (defun open-ipython-repl ()
    (interactive)
    (pop-to-buffer
     (process-buffer
      (if (or (file-exists-p "default.nix")
              (file-exists-p "shell.nix"))
          (run-python "nix-shell --command python" nil t)
        (run-python "python" nil t)))))
  (set-repl-handler! 'python-mode #'open-ipython-repl :persist t))


;; -- r (ESS)--------------------------------------------------------------------
(after! ess
  (map! :desc "Switch between buffers and repl"
        "<backtab>"
        #'ess-switch-to-inferior-or-script-buffer)
  (set-company-backend! 'ess-r-mode '(company-R-args company-R-objects company-dabbrev-code :separate))
  (setq ess-eval-visibly 'nowait)  ;; do not hang the editor on R eval
  (appendq! +ligatures-extra-symbols
           '(:assign "←"
              :multiply "×"
              :true "𝐓"
              :false "𝐅"))
  (set-ligatures! 'ess-r-mode
    ;; Functional
    :def "function"
    ;; Types
    :null "NULL"
    :true "TRUE"
    :false "FALSE"
    :int "int"
    :float "float"
    :bool "bool"
    ;; Flow
    :not "!"
    :and "&&" :or "||"
    :for "for"
    :in "%in%"
    :return "return"
    ;; Other
    :assign "<-"
    :multiply "%*%")

  (setq ess-R-font-lock-keywords '((ess-R-fl-keyword:keywords . t)
    (ess-R-fl-keyword:constants . t)
    (ess-R-fl-keyword:modifiers . t)
    (ess-R-fl-keyword:fun-defs . t)
    (ess-R-fl-keyword:assign-ops . t)
    (ess-R-fl-keyword:%op% . t)
    (ess-fl-keyword:fun-calls . t)
    (ess-fl-keyword:numbers . t)
    (ess-fl-keyword:operators . t)
    (ess-fl-keyword:delimiters . t)
    (ess-fl-keyword:= . t)
    (ess-R-fl-keyword:F&T . t)))

  (defun +ess/open-r-repl (&optional arg)
    "Open an ESS R REPL"
    (interactive "P")
    (if (or (file-exists-p "default.nix")
            (file-exists-p "shell.nix"))
        (run-ess-r "nix-shell --command R")
      (run-ess-r arg))
    (current-buffer)))


;; -- Text ----------------------------------------------------------------------
;; make flyspell work with aspell
(add-hook! 'org-mode-hook (setq ispell-list-command "--list"))


;; -- popup buffer options ------------------------------------------------------
(defun ivy-posframe-display-at-top (str)
   (ivy-posframe--display str #'posframe-poshandler-frame-top-center))
(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-top)))
(ivy-posframe-mode 1) ; This line is needed


;; -- DOOM ----------------------------------------------------------------------
(after! company
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-limit 10)                      ; bigger popup window
  (setq company-echo-delay 0)                          ; remove annoying blinking
  (setq company-idle-delay 0.5)
  (setq company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
  (global-company-mode t))


(defun doom/diff-init ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "init.example.el")))


;; -- vterm ---------------------------------------------------------------------
;; I want the cmake flags to use system vterm whenever it recompiles
(setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes")


;; -- Appearance 2: electric boogaloo  ------------------------------------------
(setq fancy-splash-image "~/.config/doom/bill.png")
(setq doom-modeline-major-mode-icon t)

(defun doom-dashboard-widget-footer ()
  ;; (insert
  ;;  "\n"
  ;;  (+doom-dashboard--center
  ;;   (- +doom-dashboard--width 2)
  ;;   (with-temp-buffer
  ;;     (insert-text-button ""
  ;;                         'action (lambda (_) (browse-url "https://github.com/karetsu"))
  ;;                         'follow-link t
  ;;                         'help-echo "GitHub")
  ;;     (buffer-string)))
  "\n" )

(custom-set-faces!
  ;; base
  `(font-lock-comment-face :inherit 'font-lock-comment-face :weight bold)
  `(font-lock-doc-face :foreground ,(doom-color 'comments) :inherit 'bold-italic)
  `((line-number-current-line &override) :foreground ,(doom-color 'base4) :inherit 'bold)

  ;; doom
  `(doom-dashboard-footer-icon :foreground ,(doom-color 'red))
  `(doom-dashboard-menu-desc   :foreground ,(doom-color 'yellow))
  `(doom-dashboard-menu-title  :foreground ,(doom-color 'red))
  `(doom-dashboard-loaded      :inherit font-lock-comment-face)

  ;; haskell
  `(haskell-constructor-face   :inherit 'bold)
  `(haskell-keyword-face       :inherit 'italic :foreground ,(doom-color 'keywords))
  `(haskell-definition-face    :inherit 'bold :foreground ,(doom-color 'red))
  `(haskell-operator-face      :foreground ,(doom-color 'base4))

  ;; other appearance
  `(solaire-mode-line-inactive-face :background ,(doom-color 'bg) :foreground ,(doom-color 'bg-alt))
  `(doom-modeline-icon-inactive :background ,(doom-color 'bg-alt) :foreground ,(doom-color 'bg-alt))
  `(ivy-posframe :background ,(doom-darken (doom-color 'bg) 0.1))
  `(company-box-background :background ,(doom-darken (doom-color 'bg) 0.1))
  `(ein:cell-input-area :background ,(doom-color 'bg-alt) )
  )


;; TODO: sort this out
(use-package! direnv
  :defer
  :config (direnv-mode))

;; TODO: also sort this out
(use-package! platformio-mode
  :config
  (add-to-list 'company-backends 'company-irony)
  ;; Enable irony for all c++ files, and platformio-mode only
  ;; when needed (platformio.ini present in project root).
  (add-hook 'c++-mode-hook (lambda ()
                           (irony-mode)
                           (irony-eldoc)
                           (platformio-conditionally-enable)))

  ;; Use irony's completion functions.
  (add-hook! 'irony-mode-hook
    (define-key irony-mode-map [remap completion-at-point]
                               'irony-completion-at-point-async)

    (define-key irony-mode-map [remap complete-symbol]
              'irony-completion-at-point-async)

            (irony-cdb-autosetup-compile-options)))
