;;;; structy-defclass.asd

(asdf:defsystem #:structy-defclass
  :description "Provides deftclass, a struct-like way of defining classes"
  :author "Chris Bagley <chris.bagley@gmail.com>"
  :license "BSD 2 Clause"
  :serial t
  :components ((:file "package")
               (:file "structy-defclass")))
