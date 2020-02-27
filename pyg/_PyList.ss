;; _PyList.ss
;; Interface to PyList_Type.

(import ./_PyObject
        (only-in ./PyAPI
                 PyList_New
                 PyList_GetItem
                 PyList_Size))

(export PyList
        make-PyList
        _PyList->list
        _PyList->vector)

;; Scheme representation
(defclass (PyList PyObject) ()
  constructor: :init!
  transparent: #t)
(defmethod {:init! PyList}
  ;; TODO: Implement list->PyList
  (lambda (self)
    (let (ptr* (PyList_New 0))
      (set! (@ self ptr) ptr*)
      (set! (@ self type) 'list))))

;; PyObject* conversion
(def (_PyList->list o Py->Scm)
  (let (len (PyList_Size o))
    (let lp ((i (1- len)) (acc []))
      (if (>= i 0)
        (let (ptr (PyList_GetItem o i))
          (lp (1- i) (cons (Py->Scm ptr) acc)))
        acc))))

(def (_PyList->vector o Py->Scm)
  (let* ((len (PyList_Size o))
         (vec (make-vector len)))
    (let lp ((i (1- len)))
      (if (>= i 0)
        (let (ptr (PyList_GetItem o i))
          (vector-set! vec i (Py->Scm ptr))
          (lp (1- i)))
        vec))))
