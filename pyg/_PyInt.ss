;; _PyInt.ss
;; Interface to PyLong_Type.

(import ./_PyObject
        (only-in ./PyAPI PyLong_FromLongLong))

(export PyInt
        make-PyInt)

;; Scheme representation
(defclass (PyInt PyObject) ()
  constructor: :init!
  transparent: #t)
(defmethod {:init! PyInt}
  (lambda (self (ll 0))
    (let (ptr* (PyLong_FromLongLong ll))
      (set! (@ self ptr) ptr*)
      (set! (@ self type) 'int))))
