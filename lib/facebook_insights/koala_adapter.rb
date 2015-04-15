require "facebook_insights/errors/configuration_error"
require "facebook_insights/errors/authorization_error"
require "koala"
module FacebookInsights
  class KoalaAdapter
    def api *arguments
      @api = Koala::Facebook::API.new *arguments
      self
    end

    def oath *arguments
      @oath = Koala::Facebook::OAuth.new *arguments
      self
    end

    def get_object *arguments
      rescue_from_exceptions do
        @api.get_object *arguments
      end
    end

    def get_connections *arguments
      rescue_from_exceptions do
        @api.get_connections *arguments
      end
    end

    def exchange_access_token_info *arguments
      rescue_from_exceptions do
        @oath.exchange_access_token_info *arguments
      end
    end

    def loop_connections *arguments
      arr = []
      response = get_connections(*arguments)
      loop do
        arr << response
        response = response.next_page
        break if response.nil?
      end
      arr.flatten
    end

    private
    def rescue_from_exceptions(&block)
      begin
        yield
      rescue Koala::Facebook::AuthenticationError => message
        raise FacebookInsights::Errors::AuthorizationError, message
      rescue Koala::Facebook::OAuthTokenRequestError => message
        raise FacebookInsights::Errors::AuthorizationError, message
      end
    end
  end
end
