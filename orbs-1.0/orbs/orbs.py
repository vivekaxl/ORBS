# This file is part of the ORBS distribution.

# ORBS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# ORBS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with ORBS.  If not, see <http://www.gnu.org/licenses/>.

#
# ORBS (the sequential implementation).
#
# A simple implementation that relies strongly on external scripts.
#
# Options:
# -b: start deletion at the end.
# -i: use the specified ignore filter to delete lines before starting
# the slicing process.
# -w <delta>: set the size of the window (default is 3).
# files...: list of files to be sliced.
# 
# This version relies on caching results: It caches the output of the
# compilation so that the results for the same binary can be reused.
# It also uses caching of the generated slice so that the results for
# the generated slice can be reused.
#
# If a line contains "K$E%E^P" it will be kept and will not be sliced
# away.
#
# TODO: Multiple criteria is missing.
#
# TODO: Criterion instance is missing.
#
# TODO: It is not clear under which circumstances the caching of the
# slices is effective. It may be the case that the cached result
# should always be FAIL.
#
import commands
import sys
import os
import re
import hashlib

# Parameters for ORBS. They can be used to configure the operation.

# Size of the deletion window
delta = 3
# Slicing criterion
criterion = "ORBS"
# Forward or backward?
backward = False
# Use filter to ignore lines?
ignore_on = False

# The filter
ignore = re.compile('\s*$|\s(#|//)')

# From here on, nothing can be configured.

# Global variables.

# The list of all files to be sliced
files = []
# The list of all lines for every file to be sliced
lines = []
# Map files to line number
start_lines = {}
# Flags if a line is deleted - the slice consists of all lines where
# 'deleted' is FALSE.
deleted = []
# Cache the results of a specific slice
slice_cache = {}
# Cache the results of executing a specific binary
result_cache = {}

# Statistics:

# Number of ignored lines
count_ignored = 0
# Number of compilations
count_compiles = 0
# Number of cached compilations
count_comp_cached = 0
# Number of cached executions
count_reuses = 0
# Number of executions
count_executes = 0
# Number of main loop iterations
count_iterations = 0

# Setup the system to be sliced.
#
# The actual setup is delegated to an external script. The external
# script is expected at a specific location "config/setup.sh".
#
def setup():
    commands.getoutput('bash config/setup.sh')
    # Read the files and store them in a list.
    # Mark every line as not deleted.
    lc = 0
    for fn in files:
        start_lines[fn] = lc
        f = open(fn, "r")
        for l in f:
            lc += 1
            lines.append((fn, l))
            deleted.append(False)
    return

# Compile the system.
#
# The current system (before or after deletion) is compiled via an
# external script.  The script must return a generated signature if
# compilation was successful and must return "FAIL" if compilation was
# not successful. The signature should be, for example, an md5 hash
# over the generated binary.
#
# Returns a signature of the generated system if compilation was successful.
#
def compile(log):
    global count_compiles
    count_compiles += 1
    r = commands.getoutput('bash config/compile.sh ' + log)
    debug.write("C " + log + " " + r + "\n")
    return r

# Execute the system.
#
# The current compiled system (before or after deletion) is executed
# via an external script. The script returns the projected trajectory.
#
# Returns the projectes trajectory.
#
def execute(log):
    global count_executes
    count_executes += 1
    return commands.getoutput('bash config/execute.sh ' + criterion + " " + log)

# Generate a hash for a slice.
#
# The generated slice is turned into an md5 hash that is used to
# compare different generated slices with each other.
#
# Returns an md5 hash.
#
def hash(sliced):
    # Go through the line list.
    #
    new = hashlib.md5()
    i = 0
    while i < len(sliced):
        fn, l = lines[i]
        f = open(fn, "a")
        if not sliced[i]:
            new.update(l)
        f.close()
        i += 1
    return new.digest()
        
# Create the sliced system.
#
# Creates the files by printing all non-deleted lines.
#
def create(sliced):
    # Clear the files.
    for fn in files:
	os.remove(fn)

    # Go through the line list and print every non-deleted line into
    # its file.
    #
    # TODO: This is inefficient as each time the file is opened, the
    # line as appended, and the file is closed again.
    i = 0
    while i < len(sliced):
        fn, l = lines[i]
        f = open(fn, "a")
        if not sliced[i]:
            f.write(l)
        else:
            f.write("\n")
        f.close()
        i += 1

# Print the some statistics.
def statistics():
    count_lines = 0
    count_deletions = 0
    i = 0
    while i < len(deleted):
        count_lines += 1
        if deleted[i]:
            count_deletions += 1
        i += 1

    print "ORBS needed", count_compiles, "compilations,",
    print count_comp_cached, "cached compilations,",
    print count_executes, "executions,",
    print count_reuses, "cached executions in",
    print count_iterations, "iterations."
    print "ORBS deleted", count_deletions, "of", count_lines, "lines,",
    print count_ignored, "ignored." 

# Print the final slice and some statistics.
def success():
    count_lines = 0
    count_deletions = 0
    i = 0
    while i < len(deleted):
        count_lines += 1
        if not deleted[i]:
            fn, l = lines[i]
            print i+1, fn, l,
        else:
            count_deletions += 1
            print i+1, "-----"
        i += 1

    # on screen
    statistics()
    # to log file
    log.write(str(count_ignored) + " ignored\n")
    log.write(str(count_compiles) + " compilations\n")
    log.write(str(count_comp_cached) + " cached compilations\n")
    log.write(str(count_executes) + " executions\n")
    log.write(str(count_reuses) + " reuses\n")
    log.write(str(count_iterations) + " iterations\n")
    log.write(str(count_deletions) + " deletions\n")
    log.write(str(count_lines) + " lines\n")

# ORBS

# This is the main script.

# from now on log the actions
log = open("orbs.log", "w")
debug = open("debug.log", "w")

# Setup the system, compile, and execute it. Capture the projected
# trajectory for the orginal system.
opti = 1
while True:
    if sys.argv[opti] == "-b":
        backward = True
        opti += 1
        continue
    if sys.argv[opti] == "-i":
        ignore_on = True
        opti += 1
        continue
    if sys.argv[opti] == "-w":
        delta = int(sys.argv[opti+1])
        opti += 2
        continue
    break
    
files = sys.argv[opti:]
#
# Setup and prepare the system (delegate to script).
#
print "* setup the system"
setup()
#
# Compile the original system to ensure that it works.
#
print "* compile the system"
r = compile("setup")
if r == "FAIL":
    print "original program does not compile."
    sys.exit(-1)
# 
# Execute the orginal system and create the oracle.
#
print "* execute the system"
original = execute("setup")
result_cache[r] = original
# save the oracle
oracle = open("oracle.log", "w")
oracle.write(original)
oracle.write("\n")
oracle.close()
#
# Filter the original program and delete all lines that match the
# ignore filter.
#
if ignore_on:
    i = 0
    while i < len(deleted):
        if ignore.match(lines[i][1]):
            deleted[i] = True
            count_ignored += 1
        i += 1
    # 
    # Ensure that the filtered version compiles and creates the same binary.
    #
    print "* compile the filtered system"
    rf = compile("filtered")
    if rf == "FAIL":
        print "filtered program does not compile."
        sys.exit(-1)

    if rf != r:
        print "filtered program changed the binary."
        sys.exit(-1)
else:
    #
    # Do a sanity check by recompiling the system again.
    #
    print "* compile the system again (sanity check)"
    rf = compile("sanity")
    #
    # the sanity check must create the same binary.
    #
    if rf == "FAIL":
        print "sanity check does not compile."
        sys.exit(-1)
    if rf != r:
        print "sanity check changed the binary."
        sys.exit(-1)

#
# Sanity check for running twice. The filtered (or original program)
# will be run again to ensure that running the same binary is
# producing the same trajectory.
#
print "* execute the system again (sanity check)"
sanity = execute("sanity")
# Running the program multiple times must produce the same output
if sanity != original:
    print "non-deterministic oracle!"
    oracle = open("changedoracle.log", "w")
    oracle.write(sanity)
    oracle.write("\n")
    oracle.close()
    sys.exit(-1)

# backward or forward deletion
if backward:
    print "* ORBS backward"
    start = len(lines) - 1
    step = -1
else:
    print "* ORBS forward"
    start = 0
    step = +1


# The main loop continues until no more line can be deleted.
reduced = True
while reduced:
    reduced = False
    count_iterations += 1
    line = start
    while line >= 0 and line < len(lines):
        # set the current line and file
        c_file = lines[line][0]
        c_line = line+1-start_lines[lines[line][0]]

        # skip over all deleted lines
        if deleted[line]:
            log.write(c_file + ":" + str(c_line) + ":.\n")
            line += step
            continue

        # attempt to delete line(s)
        attempt = deleted[:]

        status = ""
        cached = False
        rc = ""

        # The deletion will start by trying to delete one line (at
        # position 'line'). If that fails (either it does not compile
        # or the generates a different projected trajectory), it
        # expands the deletion window by another line and tries again.
        # It repeats until either it succeeds (compiles and the
        # projected trajectory is the same) or the deletion window
        # gets too large.
        j = 1
        ij = line
        while j <= delta:
            # skip over already deleted lines
            while ij >= 0 and ij < len(deleted) and deleted[ij]:
                ij += step
            if ij < 0 or ij >= len(deleted):
                rc = "FAIL"
                break
            if lines[ij][1].find("K$E%E^P") >= 0:
                rc = "FAIL"
                break
            # delete the line
            attempt[ij] = True
            print "*", count_iterations, "delete " + str(line+1) + "-" + str(ij+1), "in", c_file, "at", c_line,
            # check if the slice is new
            h = hash(attempt)
            rc = "" 
            if h in slice_cache:
                # had this before
                comp_cached = True
                rc = slice_cache[h]
                count_comp_cached += 1
                print "comp cached " + str(count_comp_cached) + ":",
            else:
                # execute and capture the projected trajectory.
                comp_cached = False
                # create the files and compile them
                create(attempt)
                rc = compile(str(line+1) + "-" + str(ij+1))
                print "compile " + str(count_compiles) + ":",
                slice_cache[h] = rc
            
            if rc == "FAIL":
                # compilation failed, no valid slice possible.
                print "FAIL"
                status = "F"
                # Increase the deletion window
                ij += step
                j += 1
            else:
                # compilation succeeded.
                print "OK",
                break
            
        passes = False

        if rc != "FAIL":
            # check if we cached the result for this program instance
            if rc in result_cache:
                # executed this before
                cached = True
                projected = result_cache[rc]
                count_reuses += 1
                print "cached " + str(count_reuses) + ":",
            else:
                # execute and capture the projected trajectory.
                cached = False
                projected = execute(str(line+1) + "-" + str(ij+1))
                result_cache[rc] = projected
                print "execution " + str(count_executes) + ":",
                
            if projected == original:
                # the projected trajectory has not changed and the
                # slice is valid.
                print "UNCHANGED"
                passes = True
            else:
                # the projected trajectory has changed, the slice
                # is not valid.
                print "CHANGED"
                status = "C"

        if passes:
            # The deletion has produced a valid slice. Continue
            # deletion on this valid slice and try to deleted more.
            deleted = attempt
            reduced = True
            if cached:
                status = "Dc"
            else:
                status = "D"
            
            for i in range(0,j):
                log.write(c_file + ":" + str(c_line + i) + ":" + status + "\n")
            line += j * step

        else:
            # It is not possible to delete the current line. Try the
            # next one.
            line += step
            if cached:
                log.write(c_file + ":" + str(c_line) + ":" + status + "c\n")
            else:
                log.write(c_file + ":" + str(c_line) + ":" + status + "\n")

        log.flush()

    print "Iteration", count_iterations
    statistics()

# The last iteration could not delete a single line. We are done.
create(deleted)
success()
# All done.
