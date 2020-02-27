;; PyStr.ss
;; Interface to PyUnicode_Type.

(import ./_PyStr
        (only-in ./_PyObject PyObject->string)
        (only-in ./PyAPI ___PyUnicode_string))

(export PyStr->string
        PyUnicode->string)

;; PyObject* conversion
(def (PyStr->string o)
  (PyObject->string o))

(def (PyUnicode->string o)
  (___PyUnicode_string o))
