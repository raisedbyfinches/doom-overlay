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
(package! ess-view :pin "d4e5a340b7...")

;; redraw org tables with box-drawing characters
(package! org-pretty-table-mode
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "88380f865a...")
