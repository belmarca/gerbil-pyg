;; gxpy.ss

(import :belmarca/pyg)

(define env (start-python))

;; parameterize the environment
(+pyenv+ env)

(define pyint (PyInt 9000))
(define pyfloat (PyFloat 1.992))
(define pystring (PyString "Hello, world!"))
(define pylist1
  (Py->Scm (pyrun* "[1.0, [2, 3, [4, 5, 6, [\"Hello, world!\"]]], 7]")))
(define pylist2
  (Py->Scm (pyrun* "[i for i in range(10)]") list-conv: PyList->vector))

(displayln "pylist1: " pylist1)
(displayln "list? " (list? pylist1))

(displayln "pylist2: " pylist2)
(displayln "vector? " (vector? pylist2))

(stop-python)