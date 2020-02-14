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
            *pyobj = Py_BuildValue("s", s);
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
