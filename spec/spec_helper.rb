# VCR for recording api requests
require 'webmock/rspec'
require 'vcr'

# Lib
require "facebook_insights"

require 'bundler/setup'
Bundler.setup

# Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.ignore_request do |request|
      uri = URI(request.uri)
      uri.port == 9200
    end
    c.filter_sensitive_data('FAKE_FACEBOOK_APP_SECRET') { ENV['FACEBOOK_APP_SECRET'] }
    c.filter_sensitive_data('FAKE_FACEBOOK_APP_ID') { ENV['FACEBOOK_APP_ID'] }
    c.filter_sensitive_data('FAKE_FACEBOOK_USER_TOKEN') { ENV['FACEBOOK_USER_TOKEN'] }
  end
end

FacebookInsights.configure do |config|
  config.app_id = ENV['FACEBOOK_APP_ID']
  config.app_secret = ENV['FACEBOOK_APP_SECRET']
end
