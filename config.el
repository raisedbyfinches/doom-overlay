;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; -- Appearance ---------------------------------------------------------------
(setq doom-theme 'doom-laserwave)
(setq doom-font (font-spec :family "Iosevka Custom" :size 14))
(setq doom-big-font (font-spec :family "Iosevka Custom" :size 32))
;;(setq doom-font (font-spec :family "mononoki" :size 14))


;; -- Haskell ------------------------------------------------------------------
(after! haskell
  (setq haskell-process-type 'cabal-new-repl)
  (setq haskell-process-wrapper-function
        (lambda (argv)
          (append (list "nix-shell" "--pure" "--command")
                  (list (mapconcat 'identity argv " "))))))


;; -- Org ----------------------------------------------------------------------
(after! org
  (add-to-list 'org-modules 'org-habit t))
(setq org-directory "~/.org/"
      org-agenda-files (list org-directory)
      org-ellipsis "  "

      ;; The standard unicode characters are usually misaligned depending on the
      ;; font. This bugs me. Markdown #-marks for headlines are more elegant.
      org-bullets-bullet-list '(""))


;; -- Python -------------------------------------------------------------------
(after! python
  (defun open-ipython-repl ()
    (interactive)
    (pop-to-buffer
     (process-buffer
      (run-python "nix-shell --command python3" nil t))))
  (set-repl-handler! 'python-mode #'open-ipython-repl :persist t))



;; -- Text ---------------------------------------------------------------------
(add-hook! text-mode #'turn-on-visual-line-mode)
