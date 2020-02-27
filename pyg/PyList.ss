;; PyList.ss
;; Interface to PyList_Type.

(import ./_PyList
        ./PyObject
        (only-in ./PyAPI
                 PyList_GetItem
                 PyList_Size))

(export PyList->list
        PyList->vector
        (import: ./_PyList))

;; PyObject* conversion
(def (PyList->list o)
  (_PyList->list o Py->Scm))

(def (PyList->vector o)
  (_PyList->list o Py->Scm))
