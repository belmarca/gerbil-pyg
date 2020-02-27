;; PyInt.ss
;; Interface to PyLong_Type.

(import ./_PyInt
        (only-in ./_PyObject PyObject->string))

(export PyLong_Type->integer
        (import: ./_PyInt))

;; PyObject* conversion
(def (PyLong_Type->integer PyObject*)
  (string->number (PyObject->string PyObject*)))
