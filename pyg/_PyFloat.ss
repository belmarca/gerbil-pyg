;; _PyFloat.ss
;; Interface to PyFloat_Type.

(import ./_PyObject
        (only-in ./PyAPI PyFloat_FromDouble))

(export PyFloat
        make-PyFloat)

;; Scheme representation
(defclass (PyFloat PyObject) ()
  constructor: :init!
  transparent: #t)
(defmethod {:init! PyFloat}
  (lambda (self (f 0.0))
    (let (ptr* (PyFloat_FromDouble f))
      (set! (@ self ptr) ptr*)
      (set! (@ self type) 'float))))
