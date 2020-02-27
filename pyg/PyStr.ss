;; PyStr.ss
;; Interface to PyUnicode_Type.

(import ./_PyStr
        (only-in ./_PyObject PyObject*->string)
        (only-in ./PyAPI
                 PyUnicode_FromString
                 ___PyUnicode_string))

(export PyStr->string
        string->PyStr*
        PyUnicode->string
        (import: ./_PyStr))

;; PyObject* conversion
(def (PyStr->string o)
  (PyObject*->string o))

(def (PyUnicode->string o)
  (___PyUnicode_string o))

;; returns a PyObject*
;; use PyStr constructor to create a wrapped PyObject*
(def (string->PyStr* s)
  (PyUnicode_FromString s))
