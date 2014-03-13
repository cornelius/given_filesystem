# Copyright (c) 2014 Cornelius Schumacher <schumacher@kde.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative "../given_filesystem"

module GivenFilesystemSpecHelpers
  def self.included(example_group)
    example_group.extend(self)
  end

  def use_given_filesystem options = {}
    before do
      @__given_filesystem = GivenFilesystem.new
    end

    if !options[:keep_files]
      after do
        @__given_filesystem.cleanup
      end
    end
  end
  
  def given_directory directory_name = nil
    check_initialization
    if block_given?
      path = @__given_filesystem.directory directory_name do
        yield
      end
    else
      path = @__given_filesystem.directory directory_name
    end
    path
  end
  
  def given_directory_from_data directory_name, options = {}
    check_initialization
    path = @__given_filesystem.directory_from_data directory_name, options[:from]
  end
  
  def given_file file_name, options = {}
    check_initialization
    if !options[:from]
      options[:from] = file_name
    end
    @__given_filesystem.file file_name, options
  end
  
  def given_dummy_file file_name = nil
    check_initialization
    @__given_filesystem.file file_name
  end
  
  private
  
  def check_initialization
    if !@__given_filesystem
      raise "Call use_given_filesystem before calling other methods"
    end
  end
end
