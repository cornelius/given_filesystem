# Copyright (C) 2014 Cornelius Schumacher <schumacher@kde.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

require_relative "../given_filesystem"

module GivenFilesystemSpecHelpers
  def self.included(example_group)
    example_group.extend(self)
  end

  def use_given_filesystem
    before do
      @given_filesystem = GivenFilesystem.new
    end
    
    after do
      @given_filesystem.cleanup
    end
  end
  
  def given_directory directory_name = nil
    check_initialization
    if block_given?
      path = @given_filesystem.directory directory_name do
        yield
      end
    else
      path = @given_filesystem.directory directory_name
    end
    path
  end
  
  def given_file file_name, options = {}
    check_initialization
    if !options[:from]
      options[:from] = file_name
    end
    @given_filesystem.file file_name, options
  end
  
  def given_dummy_file file_name = nil
    check_initialization
    @given_filesystem.file file_name
  end
  
  private
  
  def check_initialization
    if !@given_filesystem
      raise "Call given_filesystem before calling other methods"
    end
  end
end
