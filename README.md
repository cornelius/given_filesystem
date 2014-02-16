# GivenFilesystem

GivenFilesystem is a set of helpers for testing code which operates on file
systems. It lets you create temporary directories and files with given content as
test data. You can write to these directories and GivenFilesystem takes care of
cleaning up after the test. It only assumes that you can set the path to your
file system data in your tests.

GivenFilesystem provides helpers for RSpec and a standalone class.

## Usage with RSpec

### Setup

To use the GivenFilesystem helpers in a RSpec test you have to include the
`GivenFileSystemSpecHelpers` module to get access to the helper methods:

```ruby
include GivenFileSystemSpecHelpers
```

To make use of the helpers you have to activate the test file system to
initialize the temporary test directory:

```ruby
use_given_filesystem
```

### Creating directories

Create a temporary directory for writing test data:

```ruby
path = given_directory
```

Use the returned path to access the directory.

Create a temporary directory with a given name for writing test data:

```ruby
path = given_directory "myname"
```

Create a directory structure:

```ruby
given_directory "mydir" do
  path = given_directory "data"
  
  do_something(path)
end
```

### Creating files

Create a temporary file with arbitrary content:

```ruby
path = given_dummy_file
```

Use the returned path to access the file.

Create a temporary file with given content:

```ruby
path = given_file "mycontent"
```

The content of the file is taken from a file stored in your `spec/data`
directory. The name of the created file is the same as the name of the file
containing the test content.

Create a temporary file with given content under a different name:

```ruby
path = given_file "myspecialdata", :from => "mycontent"
```

The content of the file is taken from the file `spec/data/mycontent` and stored
under the name `myspecialdata` in a temporary directory. You can access it under
the returned path.

### Creating structures of directories and files

You can combine `given_directory` and `given_file` to create file system
structures as input for you tests. Here is an example:

```ruby
path = given_directory "mydir" do
  given_directory "one" do
    given_file "myfile"
    given_file "myotherfile"
  end
  given_diretory "two" do
    given_file "myfile2", :from => "myfile"
  end
end
```

This will create the following file system structure and return the path to the
temporary directory, which you can then use in your tests to access the data:

```
/tmp/
  given_filesystem/
    20140216-74592/
      one/
        myfile
        myotherfile
      two/
        myfile2
```
