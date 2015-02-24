require 'koala'
module FacebookInsights
  module Authentication
    protected
    def api(access_token)
      Koala::Facebook::API.new access_token
    end
  end
end
