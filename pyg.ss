;; pyg.ss

(import :std/foreign
        (only-in :std/sugar assert!)
        (only-in :std/format format))

(export pyrun
        pyrun-string
        pyrun-simplestring
        begin-python
        end-python)

(begin-ffi (py-initialize
            py-finalize
            py-incref
            py-decref
            pyimport-addmodule
            pyimport-importmodule
            pyimport-importmoduleex
            pymodule-getdict
            pyrun-string
            pyrun-simplestring
            pydict-new
            pydict-setitemstring)

  (c-declare "
#define PY_SSIZE_T_CLEAN
#include <Python.h>

// Python 3.x only

#define TYPE_HTB(x)(x<<___HTB)

___SCMOBJ SCMOBJ_to_PyObject(___SCMOBJ scmobj, PyObject** pyobj)
{
  ___SCMOBJ e = ___FIX(___NO_ERR);

  if (___TYP(scmobj) == ___tSUBTYPED) {
    switch (___SUBTYPED_HEADER(scmobj) & ___SMASK) {
    case TYPE_HTB(___sSTRING):
      {
        char* s;
        if ((e = ___SCMOBJ_to_NONNULLCHARSTRING(___PSA(___PSTATE) scmobj, &s, 1)) == ___FIX(___NO_ERR))
          {
            *pyobj = Py_BuildValue(\"s\", s);
          } else {
          e = ___FIX(___STOC_TYPE_ERR);
        }
        break;
      }
    default:
      e = ___FIX(___NO_ERR);
    }
  } else if (___TYP(scmobj) == ___tSPECIAL) {
    switch (scmobj) {
    case ___FAL:
      {
        e = ___FIX(___NO_ERR);
        break;
      }
    case ___TRU:
      {
        e = ___FIX(___NO_ERR);
        break;
      }
    default:
      e = ___FIX(___NO_ERR);
    }
  } else {
    e = ___FIX(___NO_ERR);
  }
  return e;
}

___SCMOBJ PyObject_to_SCMOBJ(PyObject* from, ___SCMOBJ* to)
{
  PyObject* repr;

  if ((repr = PyObject_Repr(from)) != NULL) {
    const char* ss = PyUnicode_AsUTF8(repr);
    ___NONNULLCHARSTRING_to_SCMOBJ(___PSTATE, ss, to, ___RETURN_POS);
  }

  Py_XDECREF(repr);

  return ___FIX(___NO_ERR);
}

#define ___BEGIN_CFUN_SCMOBJ_to_PyObject(src,dst,i) \
if ((___err = SCMOBJ_to_PyObject (src, &dst)) == ___FIX(___NO_ERR)) {
#define ___END_CFUN_SCMOBJ_to_PyObject(src,dst,i) }

#define ___BEGIN_CFUN_PyObject_to_SCMOBJ(src,dst) \
if ((___err = PyObject_to_SCMOBJ (src, &dst)) == ___FIX(___NO_ERR)) {
#define ___END_CFUN_PyObject_to_SCMOBJ(src,dst) }

#define ___BEGIN_SFUN_PyObject_to_SCMOBJ(src,dst,i) \
if ((___err = PyObject_to_SCMOBJ (src, &dst)) == ___FIX(___NO_ERR)) {
#define ___END_SFUN_PyObject_to_SCMOBJ(src,dst,i) }

#define ___BEGIN_SFUN_SCMOBJ_to_PyObject(src,dst) \
if ((___err = SCMOBJ_to_PyObject (src, &dst)) == ___FIX(___NO_ERR)) {
#define ___END_SFUN_SCMOBJ_to_PyObject(src,dst) }
")

  ;; types
  (c-define-type PyObject* "PyObject*" "PyObject_to_SCMOBJ" "SCMOBJ_to_PyObject" #f)

  (define-c-lambda py-initialize () void "Py_Initialize")
  (define-c-lambda py-finalize   () void "Py_Finalize")

  (define-c-lambda py-incref (PyObject*) void "Py_INCREF")
  (define-c-lambda py-decref (PyObject*) void "Py_DECREF")

  ;; PyImport_*
  (define-c-lambda pyimport-addmodule (nonnull-char-string) PyObject* "PyImport_AddModule")
  (define-c-lambda pyimport-importmodule (nonnull-char-string) PyObject* "PyImport_ImportModule")
  (define-c-lambda pyimport-importmoduleex (nonnull-char-string PyObject* PyObject* PyObject*) PyObject* "PyImport_ImportModuleEx")

  ;; PyModule_*
  (define-c-lambda pymodule-getdict (PyObject*) PyObject* "PyModule_GetDict")

  ;; PyDict_*
  (define-c-lambda pydict-new () PyObject* "PyDict_New")
  (define-c-lambda pydict-setitemstring (PyObject* char-string PyObject*) int "PyDict_SetItemString")

  ;; PyRun_*
  (define-c-lambda pyrun-string (nonnull-char-string int PyObject* PyObject*) PyObject* "PyRun_String")
  (define-c-lambda pyrun-simplestring (nonnull-char-string) void "PyRun_SimpleString"))

;; constants found in python's compile.h
(def +py-single-input+ 256)
(def +py-file-input+ 257)
(def +py-eval-input+ 258)
(def +py-func-type-input+ 345)

(def +py-main-module+ (make-parameter #f))
(def +py-globals+ (make-parameter #f))
;; (def +py-locals+ (make-parameter #f))

(def (pyrun s)
    (pyrun-string s +py-eval-input+ (+py-globals+) (+py-globals+)))

(def (begin-python)
  (py-initialize)
  (+py-main-module+ (pyimport-addmodule "__main__"))
  (+py-globals+     (pymodule-getdict (+py-main-module+)))
  ;; (+py-locals+      (pydict-new))
  (py-incref (+py-globals+)))

(def (end-python)
  (py-decref (+py-globals+))
  (+py-main-module+ #f)
  (+py-globals+ #f)
  ;; (+py-locals+ #f)
  (py-finalize))
