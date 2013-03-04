(defpackage :fltk-system
  (:use :cl :asdf))

(in-package :fltk-system)

;; running things like 'make' is sooo PITA! Hello guys, we are in 2013 for a God sake...

(defclass makefile (source-file)
  ())

(defmethod perform ((o load-op) (c makefile))
  t)

(defmethod perform ((o compile-op) (c makefile))
  (unless (operation-done-p o c)
	(when (find-package :fltk)
	  (set (find-symbol "*LOADED*" :fltk) nil))
	(unless
	  (zerop (run-shell-command
			  "if which gmake; then gmake -C ~S; else make -C ~:*~S; fi"
			  (namestring
			   (make-pathname :name nil
							  :type nil
							  :defaults (component-pathname c)))))
	  (error 'operation-error :component c :operation o))))

(defsystem :fltk
  :serial t
  :name "fltk"
  :version "0.1"
  :description "Binding for FLTK UI library"
  :depends-on (:cffi)
  :components
  ((makefile "Makefile")
   (:file "src/fltk")
   (:file "src/fltk-clos")
))