;; gxpy.ss

(import :belmarca/pyg)

(define env (start-python))

;; parameterize the environment
(+pyenv+ env)

;; (def requests (pyimport* "requests"))
;; (def requests.dict (PyModule_GetDict requests))
;; (def r (pyrun* "get(\"http://httpbin.org/ip\")" locals: requests.dict))
;; (def json (pyrun* "r.json()" locals: requests.dict))

(define pyint (PyInt 9000))
(define pyfloat (PyFloat 1.992))
(define pystring (PyStr "Hello, world!"))
(define pylist1
  (Py->Scm (pyrun* "[1.0, [2, 3, [4, 5, 6, [\"Hello, world!\"]]], 7]")))
(define pylist2
  (Py->Scm (pyrun* "[100.0, [i for i in range(10)]]") list-conv: PyList->vector))

(displayln "pylist1: " pylist1)
(displayln "list? " (list? pylist1))

(displayln "pylist2: " pylist2)
(displayln "vector? " (vector? pylist2))

(stop-python)
