# gerbil-pyg
Python in Gerbil.

## Usage

See `test.ss` for an example whose output is:

```
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libpython3.7m.so gxi test.ss
pylist1: #<PyObject* #19 0x7ff82514c308>
list? #f
pylist2: #(100. #(0 1 2 3 4 5 6 7 8 9))
vector? #t
pylist3: [1, 2, 3, 'Hello, world!', [4, 5], 6, [[[7.77]]]]
```
