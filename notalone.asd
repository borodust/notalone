(asdf:defsystem :notalone
  :description "Autumn 2017 Lisp Game Jam entry"
  :license "GPLv3"
  :version "1.0.0"
  :author "Pavel Korolev <dev@borodust.org>"
  :depends-on (alexandria trivial-gamekit)
  :serial t
  :components ((:file "packages")
               (:file "util")
               (:file "math")
               (:file "animation")
               (:file "player")
               (:file "zombie")
               (:file "junk")
               (:file "shotgun")
               (:file "world")
               (:file "state")
               (:file "main")))
