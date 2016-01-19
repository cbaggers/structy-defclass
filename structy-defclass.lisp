(in-package #:structy-defclass)

;; (deftclass name
;;   a
;;   (b 0)
;;   (c 0 :type fixnum))

(defmacro deftclass (name &body slots)
  (labels ((symb (&rest args)
	     (intern (format nil "~{~a~}" args)))
	   (kwd (&rest args)
	     (intern (format nil "~{~a~}" args) (find-package "KEYWORD")))
	   (option-valid (o)
	     (and (listp o)
		  (= 2 (length o))
		  (keywordp (first o))
		  (or (symbolp (second o))
		      (and (listp (second o))
			   (every #'symbolp (second o))))
		  (not (keywordp (second o)))))
	   (options-valid (options)
	     (every #'option-valid options))
	   (process-args (args)
	     (let ((name (first args))
		   (options (rest args)))
	       (if (options-valid options)
		   (cons name (apply #'append options))
		   (error "~%deftclass options malformed:~%~a"
			  (cons 'deftclass args))))))
    (destructuring-bind (name &key include constructor (conc-name nil concd))
	(process-args (if (listp name) name (list name)))
      (let* ((slots (mapcar (lambda (s) (if (listp s) s (list s nil)))
			    slots))
	     (include (if (listp include) include (list include)))
	     (constructor (or constructor (symb :make- name)))
	     (predicate (symb name :-p))
	     (conc-name (or conc-name (unless concd (kwd name :-))))
	     (slot-names (mapcar #'first slots))
	     (slot-setp (mapcar (lambda (x) (gensym (symbol-name x)))
				slot-names))
	     (conc-args (mapcar (lambda (x y) `(,x nil ,y))
				slot-names
				slot-setp))
	     (defaults (mapcar #'second slots))
	     (conc-keys (mapcan (lambda (x y z) `(,(kwd x) (if ,y ,x ,z)))
				slot-names
				slot-setp
				defaults)))
	(labels ((process-slot (slot)
		   (destructuring-bind (name _ &key type) slot
		     (declare (ignore _))
		     `(,name :initarg ,(kwd name)
			     :reader ,(if conc-name
					  (symb conc-name name)
					  name)
			     :type ,(or type t)))))
	  `(progn
	     (defclass ,name ,include
	      ,(mapcar #'process-slot slots))
	    (defun ,constructor (&key ,@conc-args)
	      (make-instance ',name ,@conc-keys))
	    (defun ,predicate (x)
	      (typep x ',name))
	    ',name))))))
