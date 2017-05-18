
%module example













extern int    gcd(int x, int y);

%typemap(in,fragment="t_output_helper") (int argc, char *argv[]) {
  int i;



  $1 = PyList_Size($input);



  $2 = (char **) malloc(($1+1)*sizeof(char *));
  for (i = 0; i < $1; i++) {
    PyObject *s = PyList_GetItem($input,i);









%#if PY_VERSION_HEX >= 0x03000000




%#else
    $2[i] = PyString_AsString(s);
%#endif

  }

}

extern int gcdmain(int argc, char *argv[]);





































































