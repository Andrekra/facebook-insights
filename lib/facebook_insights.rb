require "facebook_insights/version"
require "facebook_insights/errors/authorization_error"
require "facebook_insights/errors/configuration_error"
require "facebook_insights/user"
require "facebook_insights/authentication"
module FacebookInsights
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= FacebookInsights::Configuration.new
    yield(self.configuration)
  end

  class Configuration
    attr_accessor :app_id
    attr_accessor :app_secret
    attr_accessor :scope

    def initialize
      @app_id = ENV['FACEBOOK_APP_ID']
      @app_secret = ENV['FACEBOOK_APP_SECRET']
      @scope = 'manage_pages,read_insight'
    end
  end
end
