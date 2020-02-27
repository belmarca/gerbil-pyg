;; _PyStr.ss
;; Interface to PyLong_Type.

(import ./_PyObject
        (only-in ./PyAPI
                 PyUnicode_FromString
                 ___PyUnicode_string))

(export PyStr
        make-PyStr)

;; Scheme representation
(defclass (PyStr PyObject) ()
  constructor: :init!
  transparent: #t)
(defmethod {:init! PyStr}
  (lambda (self s)
    (let (ptr* (PyUnicode_FromString s))
      (set! (@ self ptr) ptr*)
      (set! (@ self type) 'str))))
