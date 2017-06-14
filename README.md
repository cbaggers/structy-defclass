# Structy-Defclass

I just want to make a class as easily as I can with structs


```
     (deftclass name a b c)
```

expands to

```
     (defclass name nil
       ((a :initarg :a :reader name-a :type t)
        (b :initarg :b :reader name-b :type t)
        (c :initarg :c :reader name-c :type t)))

     (defun make-name (&key (a () #:a2071) (b () #:b2072) (c () #:c2073))
       (make-instance 'name :a
                      (if #:a2071
                          a
                          nil)
                      :b
                      (if #:b2072
                          b
                          nil)
                      :c
                      (if #:c2073
                          c
                          nil)))

     (defun name-p (x) (typep x 'name))
```

The following are also supported

```
	 (deftclass (thing (:include x)
					   (:conc some-)
					   (:constructor gimme-thing))
	   a
	   (b 0)
	   (c 0 :type fixnum))
```

This also means it's easier to refactor into structs once you have done with experimenting.
