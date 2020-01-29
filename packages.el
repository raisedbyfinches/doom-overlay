;; -*- no-byte-compile: t; -*-
;;; .config/doom/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

;; -- Lua -----------------------------------------------------------------------
;;(package! flycheck-moonscript
;; :recipe (:host github :repo "hlissner/emacs-flycheck-moonscript"))

;; -- variables ----------------------------------------------------------------
(package! imenu-list)
(package! emacs-jupyter)
(package! lsp-julia)

(package! doom-nature-theme :recipe (:host github :repo "karetsu/doom-nature-theme"))
