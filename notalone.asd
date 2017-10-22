(cl:in-package :cl-user)

(defpackage :notalone.asdf
  (:use :cl :asdf))
(in-package :notalone.asdf)


(defsystem :notalone
  :description "Autumn 2017 Lisp Game Jam entry"
  :license "GNUv3"
  :version "1.0.0"
  :author "Pavel Korolev <dev@borodust.org>"
  :depends-on (alexandria trivial-gamekit)
  :serial t
  :components ((:file "packages")
               (:file "util")
               (:file "animation")
               (:file "player")
               (:file "zombie")
               (:file "junk")
               (:file "world")
               (:file "main")))
