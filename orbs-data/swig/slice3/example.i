
%module example



















































%typemap(in) (char *bytes, int len) {

%#if PY_VERSION_HEX >= 0x03000000





%#else




  $1 = PyString_AsString($input);
  $2 = PyString_Size($input);
%#endif
}

extern int count(char *bytes, int len, char c);

















































