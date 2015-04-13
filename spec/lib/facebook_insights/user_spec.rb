describe FacebookInsights::User do
  let(:token){ ENV['FACEBOOK_USER_TOKEN'] }
  describe 'accounts' do
    let(:service){ FacebookInsights::User.new(token) }

    it 'should not include accounts if the user does not have the CREATE_CONTENT permission' do
      VCR.use_cassette 'accounts' do
        expect(service.accounts.size).to eql 8
      end
    end

    it 'should include details of a page' do
      VCR.use_cassette 'accounts' do
        page = service.accounts.first
        expect(page.keys).to eql [:social_id, :name, :reach, :last_post_date, :access_token]
      end
    end

    it 'should raise an error if token is invalid' do
      VCR.use_cassette 'invalid_user_token' do
        expect{
          service = FacebookInsights::User.new 'FAKE'
          service.accounts
        }.to raise_error(FacebookInsights::Errors::AuthorizationError)
      end
    end
  end

  describe 'account' do
    let(:service){ FacebookInsights::User.new(token) }

    it 'should return basic account information' do
      VCR.use_cassette 'account' do
        page = service.account('293142237362668')
        expect(page.keys).to eql [:social_id, :name, :token_expires_at]
      end
    end
  end

  describe 'reach' do
    let(:service){ FacebookInsights::User.new(token) }

    it 'should return the lifetime insights' do
      VCR.use_cassette 'reach' do
        response = service.reach('293142237362668', since_date=Date.parse("2015-04-08"), until_date=Date.parse("2015-04-09"))
        expect(response.size).to eql 1
        expect(response.first.keys).to eql [:reach, :date]
      end
    end

    it 'should be able to specify its range upto 3 months, newest first' do
      VCR.use_cassette 'reach_90days' do
        response = service.reach('293142237362668', since_date=Date.parse("2015-01-09"), until_date=Date.parse("2015-04-09"))
        expect(response.size).to eql 90
        expect(response.first.keys).to eql [:reach, :date]
        expect(response.first[:date]).to eql '2015-04-08T07:00:00+0000'
        expect(response.last[:date]).to eql '2015-01-09T08:00:00+0000'
      end
    end

    it 'should throw an error if more then 3months is specified'
    it 'should throw an error if since > until'
  end

  describe 'country_distribution' do
    let(:service){ FacebookInsights::User.new(token) }

    it 'should return the country distribution' do
      VCR.use_cassette 'country_distribution' do
        response = service.country_distribution('293142237362668', since_date=Date.parse("2015-04-08"), until_date=Date.parse("2015-04-09"))
        expect(response.size).to eql 1
        expect(response.first.keys).to eql [:countries, :date]
        expect(response.first[:countries]).to eql({"NL"=>43, "BE"=>1, "CA"=>1, "DE"=>1})
      end
    end

    it 'should be able to specify its range up to 3 months, newest first' do
      VCR.use_cassette 'country_distribution_90days' do
        response = service.country_distribution('293142237362668', since_date=Date.parse("2015-01-09"), until_date=Date.parse("2015-04-09"))
        expect(response.size).to eql 90
        expect(response.first.keys).to eql [:countries, :date]
        expect(response.first[:date]).to eql '2015-04-08T07:00:00+0000'
        expect(response.last[:date]).to eql '2015-01-09T08:00:00+0000'
      end
    end

    it 'should throw an error if more then 3months is specified'
    it 'should throw an error if since > until'
  end

  describe 'gender_distribution' do
    let(:service){ FacebookInsights::User.new(token) }

    it 'should return the gender distribution' do
      VCR.use_cassette 'gender_distribution' do
        response = service.gender_distribution('293142237362668', since_date=Date.parse("2015-04-08"), until_date=Date.parse("2015-04-09"))
        expect(response.size).to eql 1
        expect(response.first.keys).to eql [:genders, :date]
        expect(response.first[:genders]).to eql({"male"=>27, "female"=>18, "unknown"=>1})
      end
    end

    it 'should be able to specify its range up to 3 months, newest first' do
      VCR.use_cassette 'gender_distribution_90days' do
        response = service.gender_distribution('293142237362668', since_date=Date.parse("2015-01-09"), until_date=Date.parse("2015-04-09"))
        expect(response.size).to eql 90
        expect(response.first.keys).to eql [:genders, :date]
        expect(response.first[:date]).to eql '2015-04-08T07:00:00+0000'
        expect(response.last[:date]).to eql '2015-01-09T08:00:00+0000'
      end
    end

    it 'should throw an error if more then 3months is specified'
    it 'should throw an error if since > until'
  end
  describe 'posts' do
    let(:service){ FacebookInsights::User.new(token) }
    it 'should return posts' do
      VCR.use_cassette 'posts' do
        response = service.posts('293142237362668')
        expect(response.size).to eql 5
      end
    end
  end
end
