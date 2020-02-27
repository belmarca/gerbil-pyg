;; PyObject.ss
;; Interface to PyObject.

(import ./PyAPI
        ./_PyObject
        ./PyInt
        ./PyFloat
        ./PyStr
        ./_PyList)

(export Py->Scm
        Py->Scm*
        PyObject
        make-PyObject)

;; PyObject* conversion

;; takes a PyObject* and turns it into the proper scheme object
;; optional type to avoid an FFI call
(def (Py->Scm o (type #f) list-conv: (list-conv _PyList->list))
  (if (not type)
    (let (type (___pytype o))
      (Py->Scm* o type list-conv: list-conv))
    (Py->Scm* o type list-conv: list-conv)))

;; generic conversion procedure, operates on PyObject*
(def (Py->Scm* o type list-conv: (list-conv _PyList->list))
  (case type
    ((str)    (PyStr->string o))
    ((int)    (PyLong_Type->integer o))
    ((float)  (PyFloat->flonum o))
    ((list)   (list-conv o))
    (else #f)))

;; Scheme representation
(defmethod {str PyObject}
  (lambda (self)
    (PyObject->string (@ self ptr))))

;; Conversion based on type field
(defmethod {conv PyObject}
  (lambda (self)
    (Py->Scm (@ self ptr) (@ self type))))

;; Manual conversion
(defmethod {conv* PyObject}
  (lambda (self type)
    (Py->Scm (@ self ptr) type)))
