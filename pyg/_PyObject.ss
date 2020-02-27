;; _PyObject.ss
;; Interface to PyObject*.

(import (only-in ./PyAPI
                 PyObject_Str
                 ___PyUnicode_string))

(export PyObject->string
        PyObject
        make-PyObject)

;; PyObject* conversion
(def (PyObject->string o)
  (___PyUnicode_string (PyObject_Str o)))

;; Scheme representation
(defclass PyObject (ptr type)
  transparent: #t)
