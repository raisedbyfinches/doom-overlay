;; -*- no-byte-compile: t; -*-
;;; .config/doom/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! direnv)
(package! just-mode)
(package! janet-mode)
(package! xenops)
(package! typst-ts-mode
  :recipe (:host codeberg
           :repo "meow_king/typst-ts-mode"))
