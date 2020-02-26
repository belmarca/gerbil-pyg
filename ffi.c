#define PY_SSIZE_T_CLEAN
#include <Python.h>

// Python 3.x only


const char* pytype(PyObject* src)
{
  const char* type = src->ob_type->tp_name;
  return type;
}

___SCMOBJ PyUnicode_string(PyObject * src)
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
