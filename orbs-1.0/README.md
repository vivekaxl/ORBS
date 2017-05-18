# This file is part of the ORBS distribution.

# Copyright (c) 2014 University College London

# This software is licensed under GPL version 3 and may be
# redistributed strictly under the terms of that licence a copy of
# which can be found in the file COPYING. If you are interested in a
# commercial licence for commercial redistribution purposes, please
# contact Jens Krinke <j.krinke@ucl.ac.uk>.

# See the file LICENSE.TXT for more information.

This is the distribution for (sequential) ORBS. The distribution is
located at <http://crest.cs.ucl.ac.uk/resources/orbs/>.

If you use ORBS for your own research in any way, please cite the ORBS
paper:

D. Binkley, N. Gold, M. Harman, S. Islam, J. Krinke, S. Yoo:
ORBS: Language-Independent Program Slicing.
Foundations of Software Engineering (FSE),
Hong Kong, China, November 2014.

The distribution comes with two examples in the _projects_ directory:

* _example_ contains the example from the FSE 2014 paper on ORBS.

* _mbe_ contains another example, the so-called "Montreal Boat Example".

Structure
=========

The structure of the examples is always the same:

The _config_ directory contains the scripts necessary to apply the
different phases of ORBS

* _config.sh_ contains the configuration of the project and is sourced
  by the other scripts in the _config_ directory.

* _setup.sh_ is invoked by ORBS to prepare the project for ORBS,
  mainly copying the original project into the working space and
  instrumenting the code.

* _compile.sh_ is invoked by ORBS to compile the project in the
  working space.

* _execute.sh_ is invoked by ORBS to execute the compiled project in
  the working space.

* _orbs.sh_ is actually invoking ORBS for this example project.

Running the Examples
====================

It is straightforward to run apply ORBS to the examples.  It should be
sufficient to just invoke ORBS via ``bash ./config/orbs.sh''.  Note that
it has to be invoked from the main directory of the project, so do a
``cd projects/example'' or ``cd projects/mbe'' first.

However, you may want to pass the parameters ``-b -i'' to ORBS so that
it operates backwards and enables a filter that ignores empty lines
and comments.

When ORBS has finished, the slice can be found in the _work_
directory.  In addition, there are a few log files in the current
directory and in the _work_ directory:

* _oracle.log_ contains the trajectory of the original (unmodified)
  program.

* _orbs.log_ lists every considered line with the result. In addition,
  it contains some statistics about running ORBS.

* _debug.log_ contains some more details about the results of the
  compilation and execution.

* _work/compile.log_ contains the compilation results of the last
  compilation.

* _work/execute.log_ contains the result of the last execution (stderr).

* _work/test.log_ contains the output of the last execution (stdout).

Note that the two log files in the _work_ directory are created by the
corresponding scripts in _config_.

Using the Example as a Template
===============================

To change the example to a different project, all the scripts in
_config_ have to be adapted.

Prerequisites
=============

To succesfully run ORBS on the examples, yo have to have the following
installed:

* Python

* bash

* gtimeout (the GNU version of timeout. If it is installed as timeout,
  please change the _config/execute.sh_ script in _projects/mbe_
  accordingly).

* javac, the Java compiler

* gcc, the C compiler
