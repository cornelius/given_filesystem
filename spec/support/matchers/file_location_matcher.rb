require 'pathname'
require 'rspec/expectations'

RSpec::Matchers.define :be_located_under do |expected|
  match do |actual|
    Pathname.new(actual).fnmatch? File.join(expected, '**')
  end
end
