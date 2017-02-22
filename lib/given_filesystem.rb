# Copyright (c) 2014-2015 Cornelius Schumacher <schumacher@kde.org>
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

require "tmpdir"

class GivenFilesystem
  def initialize
    @path_elements = [ Dir.tmpdir, "given_filesystem" ]
    @base_paths = Array.new
  end
  
  def cleanup
    @base_paths.each do |base_path|
      # Better safe than sorry, so do sanity check on path before removing it
      if base_path =~ /given_filesystem/
        FileUtils.rm_r base_path
      end
    end
  end

  def directory user_provided_directory = nil
    create_random_base_path unless path_has_base?

    directory_to_create = user_provided_directory || random_name

    @path_elements.push directory_to_create

    created_path = path
    FileUtils.mkdir_p created_path
    yield if block_given?
    @path_elements.pop

    File.join path, first_segment_of_path(directory_to_create)
  end
  
  def directory_from_data to, from = nil
    from ||= to

    create_random_base_path unless path_has_base?

    FileUtils.mkdir_p path
    @path_elements.push to

    created_path = path
    FileUtils.cp_r test_data_path(from), path
    @path_elements.pop
    created_path
  end

  def file file_name = nil, options = {}
    create_random_base_path unless path_has_base?
    
    if file_name
      @path_elements.push file_name
    else
      @path_elements.push random_name
    end
 
    FileUtils.mkdir_p File.dirname(path)
 
    created_path = path
    File.open(created_path,"w") do |file|
      if options[:from]
        test_data = test_data_path(options[:from])
        if !File.exists? test_data
          raise "Test data file '#{test_data}' doesn't exist"
        end
        file.write File.read(test_data)
      else
        file.puts "GivenFilesystem was here"
      end
    end
    @path_elements.pop
    created_path
  end

  private
  
  def create_random_base_path
    @path_elements.push random_name
    @base_paths.push path
  end
  
  def random_name
    "#{Process.pid}-#{Time.now.strftime("%Y%m%d")}-#{rand(99999).to_s}"
  end
  
  def path
    @path_elements.join("/")
  end
  
  def path_has_base?
    @path_elements.count > 2
  end
  
  def test_data_path name
    File.expand_path('spec/data/' + name)
  end

  def first_segment_of_path path
    path.split(File::SEPARATOR).reject(&:empty?).first
  end
end
