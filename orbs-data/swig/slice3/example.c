




























int count(char *bytes, int len, char c) {
  int i;
  int count = 0;
  for (i = 0; i < len; i++) {
    if (bytes[i] == c) count++;
  }
  printf("\nORBS: %d\n",count);return count;
















}
