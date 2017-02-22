# Change log of given_filesystem

All source code releases can be found at
https://github.com/cornelius/given_filesystem/releases

## Version 0.2.0

Correct behavior of `given_directory` with a nested path. It used to return
the path to the lowest directory in the hierarchy, the one pointed to by the
full path provided as argument to `given_directory`. The intended and
documented behavior is to return the path to the to the base of the created
directories. This release fixes the behavior.

If you rely on the previous (incorrect) behavior you might have to adapt
your tests.

## Version 0.1.2

This release fixes a bug, that when multiple sub directories where created
from test data, they were put in a nested structure, not a flat one. The bug
occurred, when you used code like this:

  given_directory do
    given_directory_from_data "one"
    given_directory_from_data "two"
  end

## Version 0.1.1

This release fixes a bug that prevented given_filesystem to be used in around
blocks in RSpec.

## Version 0.1.0

This is the initial release of GivenFilesystem, a library for setting up files
for testing. It comes with RSpec helpers to set up files and directories with
dummy or given data. The only assumption is that you can set the path to where
the data is coming from.
