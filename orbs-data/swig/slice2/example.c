





int gcd(int x, int y) {
  int g;

  while (x > 0) {
    g = x;
    x = y % x;

  }
  printf("\nORBS: %d\n", g); return g;
}

int gcdmain(int argc, char *argv[]) {
  int x,y;




  x = atoi(argv[1]);
  y = atoi(argv[2]);
  printf("gcd(%d,%d) = %d\n", x,y,gcd(x,y));


























}
