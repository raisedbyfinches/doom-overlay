;;; .config/doom/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(setq doom-theme 'doom-nord)
(setq doom-font (font-spec :family "Iosevka Custom" :size 14))

(setq haskell-process-type 'cabal-new-repl)
(setq haskell-process-wrapper-function
      (lambda (argv)
        (append (list "nix-shell" "--pure" "--command")
                (list (mapconcat 'identity argv " ")))))
