require 'factory_girl'

require_relative '../lib/zonomi.rb'

# Define your real api_key
TEST_API_KEY = ENV["ZONOMI_TEST_API_KEY"]

# Define your real test domain
TEST_DOMAIN_NAME = ENV["ZONOMI_TEST_DOMAIN_NAME"]

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.find_definitions
