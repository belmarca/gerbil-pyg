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
        Scm->Py
        PyObject
        make-PyObject
        (import: ./_PyObject))

;; PyObject* conversion

;; we need a parameter to propagate the conversion function choice
;; throughout the lifetime of the calls
(def +list-conv+ (make-parameter (lambda (x) x)))

;; takes a PyObject* and turns it into the proper scheme object
;; optional type to avoid an FFI call
(def (Py->Scm o (type #f) list-conv: (list-conv (+list-conv+)))
  (parameterize ((+list-conv+ list-conv))
    (if (not type)
      (let (type (___pytype o))
        (Py->Scm* o type list-conv: list-conv))
      (Py->Scm* o type list-conv: list-conv))))

;; generic conversion procedure, operates on PyObject*
(def (Py->Scm* o type list-conv: (list-conv (+list-conv+)))
  (parameterize ((+list-conv+ list-conv))
    (case type
      ((str)    (PyStr->string o))
      ((int)    (PyLong_Type->fixnum o))
      ((float)  (PyFloat->flonum o))
      ((list)   (list-conv o))
      (else #f))))

;; generic scheme to python conversion
(def (Scm->Py o)
  (cond
   ((integer? o) (fixnum->PyInt* o))
   ((flonum? o)  (flonum->PyFloat* o))
   ((string? o)  (string->PyStr* o))
   ((pair? o)    (_list->PyList* o Scm->Py))
   (else (error "cannot convert object" o))))

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
