;; PyFloat.ss
;; Interface to PyFloat_Type.

(import ./_PyFloat
        (only-in ./PyAPI PyFloat_FromDouble)
        (only-in ./_PyObject PyObject*->string))

(export PyFloat->flonum
        flonum->PyFloat*
        (import: ./_PyFloat))

;; PyObject* conversion
(def (PyFloat->flonum o)
  (string->number (PyObject*->string o)))

;; returns a PyObject*
;; use PyFloat constructor to create a wrapped PyObject*
(def (flonum->PyFloat* i)
  (PyFloat_FromDouble i))
