
import commands
import sys

use_locale = True
currency = "?"


if use_locale:

  decimal = commands.getoutput('./reader 1')

cmd = ('java checker ' + currency
       + sys.argv[1] + decimal + sys.argv[2])
print commands.getoutput(cmd)
