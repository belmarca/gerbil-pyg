;; PyInt.ss
;; Interface to PyLong_Type.

(import ./_PyInt
        (only-in ./PyAPI PyLong_FromLongLong)
        (only-in ./_PyObject PyObject*->string))

(export PyLong_Type->fixnum
        fixnum->PyInt*
        (import: ./_PyInt))

;; PyObject* conversion
(def (PyLong_Type->fixnum PyObject*)
  (string->number (PyObject*->string PyObject*)))

;; returns a PyObject*
;; use PyInt constructor to create a wrapped PyObject*
(def (fixnum->PyInt* i)
  (PyLong_FromLongLong i))
