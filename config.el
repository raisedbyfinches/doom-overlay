;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; place your private configuration here
;; -- Me ------------------------------------------------------------------------
(setq user-full-name "Aloysius"
      user-mail-address "myogibo@gmail.com")

;; -- Theme ---------------------------------------------------------------------
(setq doom-theme 'doom-horizon)

;; fonts
(setq doom-font (font-spec :family "Iosevka Custom" :size 14 :style "regular")
      doom-big-font (font-spec :family "Iosevka Custom" :size 18 :style "regular")
      doom-variable-pitch-font (font-spec :family "Rounded Mplus 1c" :size 14 )
      doom-unicode-font (font-spec :family "Iosevka Custom" :size 13))
;;doom-unicode-font (font-spec :family "Rounded Mplus 1c" :size 13))

;; modeline
(setq doom-modeline-buffer-encoding nil)
(setq doom-modeline-major-mode-icon nil)
(setq doom-modeline-height 42)
(setq find-file-visit-truename t)

;; add extra padding to the modeline to prevent it overflowing
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes check input-method buffer-encoding major-mode process vcs "  ")))


;; prompts
(setq which-key-idle-delay 0.5)

;; whitespace mode
(global-whitespace-mode +1)
(global-whitespace-newline-mode 0)

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
(display-time-mode 1)

;; slightly nicer default buffer names
(setq doom-fallback-buffer-name "-Doom-"
      +doom-dashboard-name "Doomboard")

;; prettify treemacs
(after! treemacs
  (add-hook! 'treemacs-mode-hook (setq window-divider-mode -1
                                       variable-pitch-mode 1
                                       treemacs-follow-mode 1)))

;; -- BUG FIXES -----------------------------------------------------------------
;; flymake is broken wrt haskell-mode
(setq flymake-allowed-file-name-masks nil)



;; -- haskell -------------------------------------------------------------------
(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "fourmolu"))


;; -- Org -----------------------------------------------------------------------
(add-hook! 'org-mode-hook
  (set-fill-column 2000)
  (+word-wrap-mode t)
  (writeroom-mode t)
  (writegood-mode t)
  (display-line-numbers-mode -1)
  (setq display-line-numbers-type nil)
  (mixed-pitch-mode 0))
(after! org
  (add-to-list 'org-modules 'org-habit t)
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
      org-journal-dir "~/.org/journal/"
      org-journal-date-format "%a, %d %B %Y"
      org-journal-file-type `weekly
      org-agenda-files (list org-directory)
      org-ellipsis "  "
      org-hide-emphasis-markers t
      org-bullets-bullet-list '(""))

(setq org-agenda-files '("~/.org/work.org"
                         "~/.org/egs.org"))
(setq org-journal-enable-agenda-integration t)


;; Python --------------------------------------------------------------------
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
  (setq ess-eval-visibly 'nowait)  ;; do not hang the editor on R eval
  (appendq! +ligatures-extra-symbols
            '(:assign "←"
              :multiply "×"))
  (add-hook! 'ess-r-mode-hook (highlight-numbers-mode -1))

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

  (setq ess-R-font-lock-keywords '(
                                   (ess-R-fl-keyword:keywords . t)
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
                                   (ess-R-fl-keyword:F&T . t))))

;; -- Text ----------------------------------------------------------------------
;; make flyspell work with aspell
(add-hook! 'org-mode-hook (setq ispell-list-command "--list"))

;; -- DOOM ----------------------------------------------------------------------
(defun doom/diff-init ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "templates/init.example.el")))


;; -- vterm ---------------------------------------------------------------------
;; I want the cmake flags to use system vterm whenever it recompiles
(setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes")


;; -- Appearance 2: electric boogaloo  ------------------------------------------
(setq fancy-splash-image "~/.config/doom/images/lion-head.png")
(setq doom-modeline-major-mode-icon t)

(custom-set-faces!
  ;; base
  `(font-lock-comment-face :inherit 'font-lock-comment-face :weight bold)
  `(font-lock-doc-face :foreground ,(doom-color 'comments) :inherit 'bold-italic)
  `((line-number-current-line &override) :foreground ,(doom-color 'base4) :inherit 'bold)
  `(whitespace-space :foreground ,(doom-lighten (doom-color 'bg-alt) 0.05))
  `(whitespace-newline :foreground ,(doom-color 'bg))

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
