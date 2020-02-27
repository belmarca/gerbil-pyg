;; PyFloat.ss
;; Interface to PyFloat_Type.

(import ./_PyFloat
        (only-in ./_PyObject PyObject->string))

(export PyFloat->flonum
        (import: ./_PyFloat))

;; PyObject* conversion
(def (PyFloat->flonum o)
  (string->number (PyObject->string o)))
