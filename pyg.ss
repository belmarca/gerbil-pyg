;; pyg.ss

(import :belmarca/pyg/PyAPI
        :belmarca/pyg/PyObject
        :belmarca/pyg/PyInt
        :belmarca/pyg/PyFloat
        :belmarca/pyg/PyStr
        :belmarca/pyg/PyList)

(export (import: :belmarca/pyg/PyAPI
                 :belmarca/pyg/PyObject
                 :belmarca/pyg/PyInt
                 :belmarca/pyg/PyFloat
                 :belmarca/pyg/PyStr
                 :belmarca/pyg/PyList)
        +py-main-module+
        +py-globals+
        +pyenv+
        %pyenv
        start-python
        stop-python
        pyrun
        pyrun*)

(def +py-main-module+ (make-parameter #f))
(def +py-globals+ (make-parameter #f))
(def +pyenv+ (make-parameter #f))

(defstruct %pyenv (__main__ __main__dict))

(def (start-python)
  (Py_Initialize)
  (let* ((__main__ (PyImport_AddModule "__main__"))
         (__main__dict (PyModule_GetDict __main__))
         (pyenv (make-%pyenv __main__ __main__dict)))
    pyenv))

(def (stop-python)
  (Py_Finalize))

(def (pyrun s) (PyRun_SimpleString s))

(def (pyrun* s pyenv: (pyenv (+pyenv+)) locals: (locals #f))
  (if (not locals)
    (PyRun_String s Py_eval_input
                  (%pyenv-__main__dict pyenv)
                  (%pyenv-__main__dict pyenv))
    (PyRun_String s Py_eval_input
                  (%pyenv-__main__dict pyenv)
                  locals)))
