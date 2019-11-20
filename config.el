;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; -- Appearance ----------------------------------------------------------------
(setq doom-theme 'doom-nord)
(setq doom-font (font-spec :family "Iosevka Custom" :size 14))


;; -- Haskell -------------------------------------------------------------------
(after! haskell
  (setq haskell-process-type 'cabal-new-repl)
  (setq haskell-process-wrapper-function
        (lambda (argv)
          (append (list "nix-shell" "--pure" "--command")
                  (list (mapconcat 'identity argv " "))))))


;; -- Org -----------------------------------------------------------------------
(after! org
  (add-to-list 'org-modules 'org-habit t))
(setq org-directory "~/.org/"
      org-agenda-files (list org-directory)
      org-ellipsis "  "

      ;; The standard unicode characters are usually misaligned depending on the
      ;; font. This bugs me. Markdown #-marks for headlines are more elegant.
      org-bullets-bullet-list '(""))


;; -- Text ----------------------------------------------------------------------
(add-hook! text-mode #'turn-on-visual-line-mode)
