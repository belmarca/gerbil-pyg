;; PyAPI.ss
;; Foreign function interface.

;; All ffi functions are prefixed with ffi/

(import :std/foreign)

(export #t)

(begin-ffi (
            ;; Constants
            Py_eval_input
            Py_file_input
            Py_single_input
            PY_VERSION_HEX
            PY_MAJOR_VERSION
            PY_MINOR_VERSION
            PY_MICRO_VERSION

            ;; Initialization, Finalization, and Threads
            Py_Initialize
            Py_Finalize
            Py_SetProgramName

            ;; Reference Counting
            Py_INCREF
            Py_XINCREF
            Py_DECREF
            Py_XDECREF
            Py_CLEAR

            ;; PyImport_*
            PyImport_AddModule
            PyImport_AddModuleObject
            PyImport_ImportModule
            PyImport_ImportModuleEx

            ;; PyRun_*
            PyRun_SimpleString
            PyRun_String
            PyRun_String*

            ;; PyModule_*
            PyModule_GetDict

            ;; PyDict_*
            PyDict_New
            PyDict_SetItemString
            PyDict_DelItemString
            PyDict_GetItemString

            ;; PyObject_*
            PyObject_HasAttr
            PyObject_HasAttrString
            PyObject_GetAttr
            PyObject_GetAttrString
            PyObject_SetAttrString
            PyObject_Repr
            PyObject_Str
            PyObject_Bytes
            PyObject_Call
            PyObject_CallObject
            PyObject_CallMethod
            PyObject_IsTrue
            PyObject_Not
            PyObject_Type
            PyObject_GetItem
            PyObject_SetItem
            PyObject_DelItem

            ;; PyList_*
            PyList_Check
            PyList_CheckExact
            PyList_New
            PyList_Size
            PyList_GetItem
            PyList_SetItem
            PyList_Insert
            PyList_Append
            PyList_AsTuple

            ;; PyUnicode_*
            PyUnicode_FromString
            ___PyUnicode_string

            ;; PyLong_*
            PyLong_FromLongLong
            
            ;; PyFloat_*
            PyFloat_FromDouble

            ;; Reflection
            PyEval_GetGlobals

            ;; Other
            ___pytype
            )

  (define-macro (map-macro macro lst)
    (if (not (null? (car lst)))
      (let lp ((lst (cdr lst))
               (acc (cons `(,macro ,@(car lst)) '())))
        (if (null? lst)
          `(begin ,@acc)
          (lp (cdr lst) (cons `(,macro ,@(car lst)) acc))))))

  (define-macro (PyAPI id args ret #!optional (f #f))
    (let ((sid (if f f (symbol->string id))))
      ;; (id* (string->symbol (string-append "ffi/" (symbol->string id)))))
      `(define ,id
         (c-lambda ,args ,ret ,sid))))

  (define-macro (with-PyAPI . args)
    `(map-macro PyAPI ,args))

  (c-declare "
#define PY_SSIZE_T_CLEAN
#include <Python.h>

// Python 3.x only


const char* ___pytype(PyObject* src)
{
  const char* type = src->ob_type->tp_name;
  return type;
}

___SCMOBJ ___PyUnicode_string(PyObject * src)
{
    ___SCMOBJ obj;

    if (PyUnicode_CheckExact(src)) {

  Py_ssize_t len;

  if (PyUnicode_READY(src))	/* convert to canonical representation */
      return ___FIX(___CTOS_HEAP_OVERFLOW_ERR);

  len = PyUnicode_GET_LENGTH(src);

  obj = ___alloc_scmobj(___PSTATE, ___sSTRING, len << ___LCS);

  if (___FIXNUMP(obj))
      return ___FIX(___CTOS_HEAP_OVERFLOW_ERR);

  switch (PyUnicode_KIND(src)) {
  case PyUnicode_1BYTE_KIND:
      {
    Py_UCS1 *data = PyUnicode_1BYTE_DATA(src);
    while (len-- > 0)
        ___STRINGSET(obj, ___FIX(len), ___CHR(data[len]));
    break;
      }
  case PyUnicode_2BYTE_KIND:
      {
    Py_UCS2 *data = PyUnicode_2BYTE_DATA(src);
    while (len-- > 0)
        ___STRINGSET(obj, ___FIX(len), ___CHR(data[len]));
    break;
      }
  case PyUnicode_4BYTE_KIND:
      {
    Py_UCS4 *data = PyUnicode_4BYTE_DATA(src);
    while (len-- > 0)
        ___STRINGSET(obj, ___FIX(len), ___CHR(data[len]));
    break;
      }
  }
  return obj;
    } else {
  return ___FIX(___CTOS_TYPE_ERR);
    }
}
")

  (c-define-type PyObject* (pointer "PyObject"))
  (c-define-type Py_ssize_t ssize_t)

  (with-PyAPI
   ;; Initialization, Finalization, and Threads
   (Py_Initialize () void)
   (Py_Finalize   () void)
   (Py_SetProgramName (wchar_t-string) void)

   ;; Reference Counting
   (Py_INCREF  (PyObject*) void)
   (Py_XINCREF (PyObject*) void)
   (Py_DECREF  (PyObject*) void)
   (Py_XDECREF (PyObject*) void)
   ;; (Py_CLEAR   (PyObject*) void)

   ;; PyImport_*
   (PyImport_AddModule (nonnull-char-string) PyObject*)
   (PyImport_AddModuleObject (PyObject*) PyObject*)
   (PyImport_ImportModule    (nonnull-char-string) PyObject*)
   (PyImport_ImportModuleEx
    (nonnull-char-string PyObject* PyObject* PyObject*) PyObject*)

   ;; PyModule_*
   (PyModule_GetDict (PyObject*) PyObject*)

   ;; PyRun_*
   (PyRun_SimpleString (UTF-8-string) int)
   (PyRun_String       (UTF-8-string int PyObject* PyObject*) PyObject*)

   ;; PyDict_*
   (PyDict_New () PyObject*)
   (PyDict_SetItemString (PyObject* nonnull-char-string PyObject*) int)
   (PyDict_DelItemString (PyObject* nonnull-char-string) int)
   (PyDict_GetItemString (PyObject* nonnull-char-string) PyObject*)

   ;; PyObject_*
   (PyObject_HasAttr       (PyObject* PyObject*) int)
   (PyObject_HasAttrString (PyObject* nonnull-char-string) int)
   (PyObject_GetAttr       (PyObject* PyObject*) PyObject*) ;; New
   (PyObject_GetAttrString (PyObject* nonnull-char-string) PyObject*) ;; New
   (PyObject_SetAttrString (PyObject* nonnull-char-string PyObject*) int)
   (PyObject_Repr          (PyObject*) PyObject*) ;; New
   (PyObject_Str           (PyObject*) PyObject*) ;; New
   (PyObject_Bytes         (PyObject*) PyObject*) ;; New
   (PyObject_Call          (PyObject* PyObject* PyObject*) PyObject*) ;; New
   (PyObject_CallObject    (PyObject* PyObject*) PyObject*) ;; New
   (PyObject_CallMethod
    (PyObject* nonnull-char-string nonnull-char-string) PyObject*) ;; New
   (PyObject_IsTrue  (PyObject*) int)
   (PyObject_Not     (PyObject*) int)
   (PyObject_Type    (PyObject*) PyObject*) ;; New
   (PyObject_GetItem (PyObject* PyObject*) PyObject*) ;; New
   (PyObject_SetItem (PyObject* PyObject* PyObject*) int)
   (PyObject_DelItem (PyObject* PyObject*) int)
   (PyObject_Dir     (PyObject*) PyObject*) ;; New

   ;; PyList_*
   (PyList_Check       (PyObject*) int)
   (PyList_CheckExact  (PyObject*) int)
   (PyList_New         (Py_ssize_t) PyObject*) ;; New
   (PyList_Size        (PyObject*) Py_ssize_t)
   (PyList_GetItem     (PyObject* Py_ssize_t) PyObject*) ;; Borrowed
   (PyList_SetItem     (PyObject* Py_ssize_t PyObject*) int) ;; Stolen
   (PyList_Insert      (PyObject* Py_ssize_t PyObject*) int)
   (PyList_Append      (PyObject* PyObject*) int)
   (PyList_AsTuple     (PyObject*) PyObject*) ;; New

   ;; PyUnicode_*
   (PyUnicode_FromString (nonnull-char-string) PyObject*)
   (___PyUnicode_string (PyObject*) scheme-object)

   ;; PyLong_*
   (PyLong_FromLongLong (long-long) PyObject*)

   ;; PyFloat_*
   (PyFloat_FromDouble (double) PyObject*)

   ;; Reflection
   (PyEval_GetGlobals () PyObject*)

   )

  (define Py_eval_input    ((c-lambda () int "___return(Py_eval_input);")))
  (define Py_file_input    ((c-lambda () int "___return(Py_file_input);")))
  (define Py_single_input  ((c-lambda () int "___return(Py_single_input);")))
  (define PY_VERSION_HEX   ((c-lambda () int "___return(PY_VERSION_HEX);")))
  (define PY_MAJOR_VERSION ((c-lambda () int "___return(PY_MAJOR_VERSION);")))
  (define PY_MINOR_VERSION ((c-lambda () int "___return(PY_MINOR_VERSION);")))
  (define PY_MICRO_VERSION ((c-lambda () int "___return(PY_MICRO_VERSION);")))

  (define (ffi/pytype o)
    (string->symbol ((c-lambda (PyObject*) nonnull-char-string "___pytype") o)))

  )
