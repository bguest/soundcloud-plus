# spec_helper

require 'rubygems'
require 'bundler/setup'
# Bundler.setup

require 'soundcloud-plus' 

require 'rspec'

RSpec.configure do |config| # :nodoc: all
   # == Mock Framework
   # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
   config.mock_with :rspec

   #Focus on one test with :focus
   config.treat_symbols_as_metadata_keys_with_true_values = true
   config.filter_run :focus => true
   config.run_all_when_everything_filtered = true

end