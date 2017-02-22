require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
])

require_relative('../lib/given_filesystem/spec_helpers')

require_relative 'support/matchers/file_location_matcher'
