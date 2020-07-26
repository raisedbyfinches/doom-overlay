;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; place your private configuration here

;; -- Theme ---------------------------------------------------------------------
(setq doom-theme 'doom-horizon)

;; fonts
(setq doom-font (font-spec :family "M+ 2m" :size 14 :style "Regular"))
(setq doom-big-font (font-spec :family "M+ 2m" :size 20 :style "Regular"))
(setq doom-variable-pitch-font (font-spec :family "Overpass" :size 14 ))

;; modeline
(setq doom-modeline-buffer-encoding nil)
(setq doom-modeline-major-mode-icon nil)
(setq find-file-visit-truename t)
(setq doom-modeline-project-detection 'ffip)


;; -- Backups -------------------------------------------------------------------
(setq make-backup-files   t
      backup-by-copying   t
      delete-old-versions t
      kept-new-versions   5
      kept-old-versions   2
      version-control     t)


;; -- haskell -------------------------------------------------------------------
(after! haskell
  (setq haskell-process-type 'cabal-new-repl)
  (setq haskell-process-wrapper-function
        (lambda (argv)
          (append (list "nix-shell" "--command")
                  (list (mapconcat 'identity argv " "))))))

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
  (setq jupyter-eval-uses-overlays t))

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


;; -- locals window -------------------------------------------------------------
(use-package! imenu-list
  :commands imenu-list-smart-toggle)
(map! :map doom-leader-code-map
      ;;; > List items
      :desc "List code items" "l" #'imenu-list-smart-toggle)

;; -- popup buffer options ------------------------------------------------------
;; (defun ivy-posframe-display-at-top (str)
;;    (ivy-posframe--display str #'posframe-poshandler-frame-top-center))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-top)))
;; (ivy-posframe-mode 1) ; This line is needed

;; -- Tabs ----------------------------------------------------------------------
;; (after! tabs
;;   (setq centaur-tabs-height 40)
;;   (setq centaur-tabs-set-close-button nil)
;;   (centaur-tabs-group-by-projectile-project))


;; -- DOOM ----------------------------------------------------------------------
(after! company
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-limit 10)                      ; bigger popup window
  (setq company-echo-delay 0)                          ; remove annoying blinking
  (setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
  (global-company-mode t))


(defun doom/diff-init ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "init.example.el")))


;; -- Appearance 2: electric boogaloo  ------------------------------------------
(setq fancy-splash-image "~/.config/doom/bill.png")
(setq doom-modeline-major-mode-icon t)

(defun doom-dashboard-widget-footer ()
  (insert
   "\n"
   (+doom-dashboard--center
    (- +doom-dashboard--width 2)
    (with-temp-buffer
      (insert-text-button ""
                          'action (lambda (_) (browse-url "https://github.com/karetsu"))
                          'follow-link t
                          'help-echo "GitHub")
      (buffer-string)))
   "\n"))

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
  )



;; 'fix' Dante, just removing --pure
(defcustom dante-methods-alist
  `((styx "styx.yaml" ("styx" "repl" dante-target))
    ; (snack ,(lambda (d) (directory-files d t "package\\.\\(yaml\\|nix\\)")) ("snack" "ghci" dante-target)) ; too easy to trigger, confuses too many people.
    (new-impure-nix dante-cabal-new-nix ("nix-shell" "--run" (concat "cabal repl " (or dante-target (dante-package-name) "") " --builddir=dist/dante")))
    ;; (new-nix dante-cabal-new-nix ("nix-shell" "--pure" "--run" (concat "cabal v2-repl " (or dante-target (dante-package-name) "") " --builddir=dist/dante")))
    ;; (nix dante-cabal-nix ("nix-shell" "--pure" "--run" (concat "cabal repl " (or dante-target "") " --builddir=dist/dante")))
    (new-nix dante-cabal-new-nix ("nix-shell" "--run" (concat "cabal repl " (or dante-target (dante-package-name) "") " --builddir=dist/dante")))
    (nix dante-cabal-nix ("nix-shell" "--run" (concat "cabal repl " (or dante-target "") " --builddir=dist/dante")))
    (impure-nix dante-cabal-nix ("nix-shell" "--run" (concat "cabal repl " (or dante-target "") " --builddir=dist/dante")))
    (new-build "cabal.project.local" ("cabal" "new-repl" (or dante-target (dante-package-name) nil) "--builddir=dist/dante"))
    ;; (nix-ghci ,(lambda (d) (directory-files d t "shell.nix\\|default.nix")) ("nix-shell" "--pure" "--run" "ghci"))
    (nix-ghci ,(lambda (d) (directory-files d t "shell.nix\\|default.nix")) ("nix-shell" "--run" "ghci"))
    (stack "stack.yaml" ("stack" "repl" dante-target))
    (mafia "mafia" ("mafia" "repl" dante-target))
    (bare-cabal ,(lambda (d) (directory-files d t "..cabal$")) ("cabal" "repl" dante-target "--builddir=dist/dante"))
    (bare-ghci ,(lambda (_) t) ("ghci")))
"How to automatically locate project roots and launch GHCi.
This is an alist from method name to a pair of
a `locate-dominating-file' argument and a command line."
  :type '(alist :key-type symbol :value-type (list (choice (string :tag "File to locate") (function :tag "Predicate to use")) (repeat sexp))))
