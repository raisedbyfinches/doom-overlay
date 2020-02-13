;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; place your private configuration here

;; -- Theme ---------------------------------------------------------------------
(setq doom-theme 'doom-horizon)

;; fonts
(setq doom-font (font-spec :family "Iosevka Custom" :size 14 :style "Regular"))
(setq doom-big-font (font-spec :family "Iosevka Custom" :size 20 :style "Regular"))
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
  (setq haskell-process-type 'cabal-repl)
  (setq haskell-process-wrapper-function
        (lambda (argv)
          (append (list "nix-shell" "--pure" "--command")
                  (list (mapconcat 'identity argv " "))))))

;; -- Org -----------------------------------------------------------------------
;;-- (add-hook! 'org-mode-hook (mixed-pitch-mode 1)) -- doesn't play nice with modeline
(after! org
  (add-to-list 'org-modules 'org-habit t)
  (setq jupyter-eval-uses-overlays t)

  (appendq! +pretty-code-symbols
            '(:checkbox      ""
              :pending       ""
              :checkedbox    ""
              :results       ""
              :property      ""
              :option        "⌥"
              :title         "𝙏"
              :author        "𝘼"
              :date          "𝘿"
              :begin_quote   "❮"
              :end_quote     "❯"
              :begin_example "❮"
              :end_example   "❯"
              :em_dash       "—"))

  (set-pretty-symbols! 'org-mode
    :merge t
    :checkbox    "[ ]"
    :pending     "[-]"
    :checkedbox  "[X]"
    :results     "#+RESULTS:"
    :property    "#+PROPERTY:"
    :option      "#+OPTION:"
    :title       "#+TITLE:"
    :author      "#+AUTHOR:"
    :date        "#+DATE:"
    :begin_quote "#+BEGIN_QUOTE"
    :end_quote   "#+END_QUOTE"
    :begin_quote "#+begin_example"
    :end_quote   "#+end_example"
    :em_dash     "---"))


;; all the time org settings?
(setq org-directory "~/.org/"
      org-agenda-files (list org-directory)
      org-ellipsis "  "

      org-hide-emphasis-markers t

      ;; The standard unicode characters are usually misaligned depending on the
      ;; font. This bugs me. Markdown #-marks for headlines are more elegant.
      org-bullets-bullet-list '(""))


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


;; -- Tabs ----------------------------------------------------------------------
(after! tabs
  (setq centaur-tabs-height 40)
  (setq centaur-tabs-set-close-button nil)
  (centaur-tabs-group-by-projectile-project))


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
  `(doom-dashboard-menu-desc :foreground ,(doom-color 'yellow))
  `(doom-dashboard-menu-title :foreground ,(doom-color 'red))
  `(doom-dashboard-loaded :inherit font-lock-comment-face)

  ;; haskell
  `(haskell-constructor-face :inherit 'bold )
  `(haskell-keyword-face :inherit 'italic :foreground ,(doom-color 'keywords))
  `(haskell-definition-face :inherit 'bold :foreground ,(doom-color 'orange))
  `(haskell-operator-face :foreground ,(doom-color 'base4))

  )
