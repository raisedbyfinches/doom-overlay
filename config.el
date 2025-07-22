;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; place your private configuration here
;; -- Me ------------------------------------------------------------------------
(setq user-full-name "g"
      user-mail-address "myogibo@gmail.com"

      ;; -- Theme ---------------------------------------------------------------------
      doom-theme 'doom-horizon

      ;; fonts
      doom-font (font-spec :family "JetBrains Mono" :size 14 :style "Regular")
      doom-big-font (font-spec :family "JetBrains Mono" :size 18 :style "Regular")
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 14 )
      doom-symbol-font (font-spec :family "JetBrains Mono" :size 16 :style "Regular")

      ;; modeline
      doom-modeline-buffer-encoding nil
      doom-modeline-major-mode-icon nil
      doom-modeline-height 42
      find-file-visit-truename t

      doom-user-dir "/home/g/.config/doom/"

      ;; prompts
      which-key-idle-delay 0.5

      ;; slightly nicer default buffer names
      doom-fallback-buffer-name "-Doom-"
      +doom-dashboard-name "Doomboard"

      ;; -- Appearance 2: electric boogaloo  ------------------------------------------
      fancy-splash-image "~/.config/doom/images/lion-head.png"

      ;; -- vterm ---------------------------------------------------------------------
      ;; I want the cmake flags to use system vterm whenever it recompiles
      vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes")

;; add extra padding to the modeline to prevent it overflowing
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes check input-method buffer-encoding major-mode process vcs "  ")))


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
(display-time-mode 0)
(pixel-scroll-precision-mode 1)


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
  (mixed-pitch-mode 1))

(after! org
  ;; latex symbols
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
  (add-to-list 'org-latex-packages-alist '("" "mathtools" t))
  (add-to-list 'org-latex-packages-alist '("" "mathrsfs" t))

  ;; other org config
  (setq
   org-babel-default-header-args '((:session . "none")
                                   (:results . "replace")
                                   (:exports . "code")
                                   (:cache . "no")
                                   (:noweb . "no")
                                   (:hlines . "no")
                                   (:tangle . "no")
                                   (:comments . "link"))
   global-org-pretty-table-mode t
   org-startup-with-latex-preview t
   org-display-remote-inline-images t

   ;; all the org settings
   org-directory "~/.org/"
   org-ellipsis "  "
   org-hide-emphasis-markers t
   org-bullets-bullet-list '("")
   deft-directory "~/.org"))

(after! spell-fu
  (setq ispell-current-dictionary "en_GB"))

;; -- r (ESS)--------------------------------------------------------------------
(after! ess
  (set-popup-rules! '(("^\\*R:*\\*$" :side right :size 0.5 :ttl nil)))
  (map! :desc "Switch between buffers and repl"
        "<backtab>"
        #'ess-switch-to-inferior-or-script-buffer)
  (setq ess-eval-visibly 'nowait)  ;; do not hang the editor on R eval
  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:keywords . t)
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

  (map! (:map (ess-mode-map inferior-ess-mode-map) :g ";" #'ess-insert-assign))
  )


;; -- DOOM ----------------------------------------------------------------------
(defun doom/diff-init ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-user-dir "init.el")
               (concat doom-emacs-dir "static/init.example.el")))

