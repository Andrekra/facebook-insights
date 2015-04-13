require "facebook_insights/errors/configuration_error"
require "facebook_insights/errors/authorization_error"
require "facebook_insights/koala_adapter"

module FacebookInsights
  class User

    def initialize token
      # Todo Find a better way
      raise FacebookInsights::Errors::ConfigurationError, "Facebook app id not configured" if FacebookInsights.configuration.app_id.nil?
      raise FacebookInsights::Errors::ConfigurationError, "Facebook app secret not configured" if FacebookInsights.configuration.app_secret.nil?

      token = exchange_token(token)
      @graph = FacebookInsights::KoalaAdapter.new.api(token)
    end

    def exchange_token(token)
      # Exhange short living token (2h) to a long living (60 days)
      # https://developers.facebook.com/docs/facebook-login/access-tokens?locale=nl_NL#extending
      oath = FacebookInsights::KoalaAdapter.new.oath FacebookInsights.configuration.app_id, FacebookInsights.configuration.app_secret
      response = oath.exchange_access_token_info(token)

      # Todo: Dont renew everytime, only when expired
      @expires_at = Time.at(Time.now.to_i + response["expires"].to_i).to_datetime
      @token = response["access_token"]
    end

    def accounts
      fb_accounts = @graph.loop_connections('me', 'accounts?fields=likes,access_token,name,perms,posts.limit(1).fields(created_time)')
      fb_accounts.keep_if { |account| account['perms'].include? 'CREATE_CONTENT' }
      fb_accounts.map do |account|
        latest_post_date = account.has_key?('posts') ? DateTime.parse(account['posts']['data'].first['created_time']) : nil
        {
          social_id: account['id'],
          name: account['name'],
          reach: account['likes'],
          last_post_date: latest_post_date,
          access_token: account['access_token']
        }
      end
    end

    def account id
      account = @graph.get_object id
      {
        social_id: account['id'],
        name: account['name'],
        token_expires_at: @expires_at
      }
    end

    def reach id, since_date=(Date.today - 1), until_date=(Date.today)
      # TODO validate that end_date > start_date
      # TODO validate that start_date and end_date are max 3 months apart
      fb_reaches = @graph.get_connections(id, "insights/page_fans/lifetime", 'since': since_date.strftime('%Y-%m-%d'), 'until': until_date.strftime('%Y-%m-%d') )
      fb_reaches = fb_reaches.first.fetch("values", [])
      fb_reaches.map do |fb_reach|
        {
          reach: fb_reach['value'],
          date: fb_reach['end_time']
        }
      end.reverse
    end

    def country_distribution id, since_date=(Date.today - 1), until_date=(Date.today)
      # TODO validate that end_date > start_date
      # TODO validate that start_date and end_date are max 3 months apart
      countries = @graph.get_connections(id, "insights/page_fans_country/lifetime", 'since': since_date.strftime('%Y-%m-%d'), 'until': until_date.strftime('%Y-%m-%d') )
      countries = countries.first.fetch("values", [])
      countries.map do |fb_country|
        {
          countries: fb_country['value'],
          date: fb_country['end_time']
        }
      end.reverse
    end

    def gender_distribution id, since_date=(Date.today - 1), until_date=(Date.today)
      # TODO validate that end_date > start_date
      # TODO validate that start_date and end_date are max 3 months apart
      gender = @graph.get_connections(id, "insights/page_fans_gender_age/lifetime", 'since': since_date.strftime('%Y-%m-%d'), 'until': until_date.strftime('%Y-%m-%d') )
      gender = gender.first.fetch("values", [])
      gender.map do |fb_gender|
        genders = parse_gender(Hash(fb_gender['value']))
        {
          genders: genders,
          date: fb_gender['end_time']
        }
      end.reverse
    end

    def posts id
      feed = @graph.loop_connections(id, 'posts?fields=id,type,message,link,created_time,likes.summary(true)')#, 'since': since_date.strftime('%Y-%m-%d'), 'until': until_date.strftime('%Y-%m-%d') )
      feed.map do |item|
        {
          social_id: item['id'],
          title: nil,
          content: item['message'],
          content_type: item['type'],
          picture: item['picture'],
          link: item['link'],
          published_at:  DateTime.parse(item['created_time']),
          popularity: item['likes']['summary']['total_count']
        }
      end
    end

    private
    def parse_gender gender_hash
      # IN:
      # "{
      #   "M.25-34": 15,
      #   "F.25-34": 10,
      #   "M.18-24": 7,
      #   "F.18-24": 6,
      #   "M.35-44": 3,
      #   "F.55-64": 1,
      #   "U.25-34": 1,
      #   "F.35-44": 1,
      #   "M.45-54": 1,
      #   "M.13-17": 1
      # },
      # OUT:
      # { male: 0, female: 0, unknown: 0 }

      # Todo Handle when value is not a integer
      male_total = gender_hash.select { |k,v| k.to_s.match(/M/) }.values.inject(:+) || 0
      female_total = gender_hash.select { |k,v| k.to_s.match(/F/) }.values.inject(:+) || 0
      unknown_total = gender_hash.select { |k,v| k.to_s.match(/U/) }.values.inject(:+) || 0

      { "male" => male_total, "female" => female_total, "unknown" => unknown_total }
    end
  end
end
