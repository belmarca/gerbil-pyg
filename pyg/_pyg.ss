;; pyg.ss

(import :std/foreign
        (only-in :std/sugar assert!)
        (only-in :std/format format))


  ;; constants

  (define PyUnicode->string
    (c-lambda (PyObject*) scheme-object "PyUnicode_string"))

  (define (pytype o)
    (string->symbol ((c-lambda (PyObject*) nonnull-char-string "pytype") o)))

  )



;; (define (list->PyList* l)
;;   (let* ((len (length l))
;;          (pylist (PyList_New len)))
;;     (let lp ((l* l) (i 0))
;;       (if (and (not (null? l*)) (<= i len))
;;         (begin
;;           (PyList_SetItem pylist i (SCMOBJ_to_PyObject (car l*)))
;;           (lp (cdr l*) (+ i 1)))
;;         pylist))))

;; (include "PyInt/PyInt.ss")
(include "Py-classes.ss")

(defclass (PyDict PyObject) ()
  constructor: :init!
  transparent: #t)

;; for now create empty dict
;; but allow creation of dict from table
(defmethod {:init! PyDict}
  (lambda (self)
    (set! (@ self ptr) (PyDict_New))
    (set! (@ self type) 'dict)))

;; modifies the dict
(defmethod {set PyDict}
  (lambda (self k v)
    (PyDict_SetItemString (@ self ptr) k v)))

;; returns a pointer
(defmethod {get* PyDict}
  (lambda (self k)
    (PyObject ptr: (PyDict_GetItemString (@ self ptr) k))))

;; returns a scheme object
(defmethod {get PyDict}
  (lambda (self k)
    (Py->Scm (PyDict_GetItemString (@ self ptr) k))))

(defmethod {del PyDict}
  (lambda (self k)
    (PyDict_DelItemString (@ self ptr) k)))

;; TODO: add fromlist argument and error handling
(def (pyimport* m)
  (let (fromlist (PyList_New 0))
    (PyImport_ImportModuleEx m
                             (%pyenv-__main__dict (+pyenv+))
                             (%pyenv-__main__dict (+pyenv+))
                             fromlist)))
