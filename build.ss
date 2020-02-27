#!/usr/bin/env gxi

(import :std/build-script
        :std/make)

;; find out your proper ld and c flags with
;; /usr/bin/python3-config --ldflags --cflags
(defbuild-script
  `((gxc: "pyg/PyAPI.ss"
          "-ld-options" "-L/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu -L/usr/lib -lpython3.7m -lcrypt -lpthread -ldl  -lutil -lm  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions"
          "-cc-options" "-I/usr/include/python3.7m -I/usr/include/python3.7m  -Wno-unused-result -Wsign-compare -g -fdebug-prefix-map=/build/python3.7-HOxg7A/python3.7-3.7.3=. -specs=/usr/share/dpkg/no-pie-compile.specs -fstack-protector -Wformat -Werror=format-security  -DNDEBUG -g -fwrapv -O3 -Wall")
    "pyg/_PyObject.ss"
    "pyg/_PyInt.ss"
    "pyg/_PyFloat.ss"
    "pyg/_PyStr.ss"
    "pyg/_PyList.ss"
    "pyg/PyInt.ss"
    "pyg/PyFloat.ss"
    "pyg/PyStr.ss"
    "pyg/PyObject.ss"
    "pyg/PyList.ss"
    "pyg.ss"
    ))
