

#include <locale.h>

int main(int argc, char **argv) {

  struct lconv *cur_locale = localeconv();

  {
    printf("%s\n", cur_locale->decimal_point);




  }

}
