# gerbil-pyg
Python in Gerbil.

## Usage

You can execute pure python:

```scheme
> (import :belmarca/pyg)
> (pyg "for i in range(10): print(i)")
0
1
2
3
4
5
6
7
8
9
```

Or use `LD_PRELOAD` to load Python's shared library and import Python modules:

```scheme
$ LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libpython3.7m.so gxi
> (import :belmarca/pyg)
> (begin-python
    (pyrun-simplestring "import requests")
    (pyrun-simplestring "r = requests.get(\"http://httpbin.org/ip\")")
    (pyrun-simplestring "print(r.json())"))
{'origin': 'x.x.x.x'}
```

;; (begin-python
;;  (pyrun-simplestring "import requests")
;;  (pyrun-simplestring "r = requests.get(\"http://httpbin.org/ip\")")
;;  (pyrun-simplestring "print(r.json())"))

;; (pyrun "import requests
;; r = requests.get(\"http://httpbin.org/ip\")
;; print(r.json())")

;; (pyrun "import matplotlib.pyplot as plt
;; plt.plot([1, 2, 3, 4])
;; plt.ylabel('some numbers')
;; plt.show()")

;; (pyrun "import matplotlib.pyplot as plt
;; import numpy as np
;; import sys
;; sys.argv = ['']
;; t = np.arange(0.0, 2.0, 0.01)
;; s = 1 + np.sin(2*np.pi*t)
;; plt.plot(t, s)
;; plt.xlabel('time (s)')
;; plt.ylabel('voltage (mV)')
;; plt.title('About as simple as it gets, folks')
;; plt.grid(True)
;; plt.show()")
