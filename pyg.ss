;; pyg.ss

(import :std/foreign)

(export pyg)

(begin-ffi (py-initialize
            py-finalize
            pyrun-simplestring)
  (c-declare "#include <Python.h>")
  (define-c-lambda py-initialize () void "Py_Initialize")
  (define-c-lambda py-finalize   () void "Py_Finalize")
  (define-c-lambda pyrun-simplestring (char-string) void "PyRun_SimpleString"))

(def (pyg s)
  (py-initialize)
  (pyrun-simplestring s)
  (py-finalize))