;; PyList.ss
;; Interface to PyList_Type.

(import ./_PyList
        (only-in ./PyObject
                 Py->Scm
                 Scm->Py))

(export PyList->list
        PyList->vector
        list->PyList*
        (import: ./_PyList))

;; PyObject* conversion
(def (PyList->list o)
  (_PyList->list o Py->Scm))

(def (PyList->vector o)
  (_PyList->vector o Py->Scm))

;; returns a PyObject*
;; use PyList constructor to create a wrapped PyObject*
(define (list->PyList* l)
  (_list->PyList* l Scm->Py))
