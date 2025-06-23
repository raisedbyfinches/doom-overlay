;; -*- no-byte-compile: t; -*-
;;; .config/doom/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! direnv)
(package! imenu-list)

;; for some reason org noter doesn't add these automatically
(package! djvu)
(package! nov)

;; replace LaTeX with xenops
(package! xenops)

;; then replace LaTeX with Typst :)
(package! typst-ts-mode
  :recipe (:host codeberg
           :repo "meow_king/typst-ts-mode"))

;; test out this copilot guff
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

(package! copilot-chat
  :recipe (:host github :repo "chep/copilot-chat.el" :files ("*.el")))
