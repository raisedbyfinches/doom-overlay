;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; place your private configuration here

;; -- appearance ----------------------------------------------------------------
(setq doom-theme 'doom-horizon)

(setq doom-font (font-spec :family "Iosevka Custom" :size 14 :style "Regular"))
(setq doom-big-font (font-spec :family "Iosevka Custom" :size 20 :style "Regular"))
(setq doom-variable-pitch-font (font-spec :family "Overpass" :size 26 ))


;; -- Backups -------------------------------------------------------------------
(setq make-backup-files t
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)


;; -- haskell -------------------------------------------------------------------
(after! haskell
  (setq haskell-process-type 'cabal-repl)
  (setq haskell-process-wrapper-function
        (lambda (argv)
          (append (list "nix-shell" "--pure" "--command")
                  (list (mapconcat 'identity argv " "))))))


;; -- Org -----------------------------------------------------------------------
(after! org
  (add-to-list 'org-modules 'org-habit t)
  (setq jupyter-eval-uses-overlays t))
(setq org-directory "~/.org/"
      org-agenda-files (list org-directory)
      org-ellipsis "  "

      org-hide-emphasis-markers t

      ;; The standard unicode characters are usually misaligned depending on the
      ;; font. This bugs me. Markdown #-marks for headlines are more elegant.
      org-bullets-bullet-list '("")) ;'("" "" "" ""))


;; -- Python --------------------------------------------------------------------
(after! python
  (defun open-ipython-repl ()
    (interactive)
    (pop-to-buffer
      (process-buffer
        (if (or (file-exists-p "default.nix")
                (file-exists-p "shell.nix"))
          (run-python "nix-shell --command python3" nil t)
          (run-python "python3" nil t)))))
  (set-repl-handler! 'python-mode #'open-ipython-repl :persist t))


;; -- ESS -----------------------------------------------------------------------
(after! ess
  (defun +ess/open-r-repl (&optional arg)
    "Open an ESS R REPL"
    (interactive "P")
    (if (or (file-exists-p "default.nix")
            (file-exists-p "shell.nix"))
        (run-ess-r "nix-shell --command R")
        (run-ess-r arg))
    (current-buffer)))


;; -- LSPs ----------------------------------------------------------------------


;; -- Text ----------------------------------------------------------------------
;; make flyspell work with aspell
(setq ispell-list-command "--list")


;; -- locals window -------------------------------------------------------------
(use-package! imenu-list
  :commands imenu-list-smart-toggle)
(map! :map doom-leader-code-map
      ;;; > List items
      :desc "List code items" "l" #'imenu-list-smart-toggle)


;; -- DOOM ----------------------------------------------------------------------
(after! company
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-limit 20)                      ; bigger popup window
  (setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
  (setq company-echo-delay 0)                          ; remove annoying blinking
  (setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
  (global-company-mode t))
