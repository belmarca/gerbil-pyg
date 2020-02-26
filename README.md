# gerbil-pyg
Python in Gerbil.

## Usage

See `test.ss` for an example whose output is:

```
$ LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libpython3.7m.so gxi test.ss
pylist1: (1. (2 3 (4 5 6 (Hello, world!))) 7)
list? #t
pylist2: #(0 1 2 3 4 5 6 7 8 9)
vector? #t
```
