# Facebook Insights

A gem to quickly get some insights about a users page. The statistics aren't supposed to be (over)complete, but quickly give an overview. The goal is, to do this for every social media channel (twitter, youtube, instagram and google analytics(websites))

[![Build Status](https://travis-ci.org/Andrekra/facebook-insights.svg)](https://travis-ci.org/Andrekra/facebook-insights)

## Environment variables (for specs)
`FACEBOOK_APP_ID=FAKE_FACEBOOK_APP_ID`
`FACEBOOK_APP_SECRET=FAKE_FACEBOOK_APP_SECRET`
`FACEBOOK_USER_TOKEN=FAKE_FACEBOOK_USER_TOKEN`

## Usage

Get an access_token from the user using your own methods. The permissions that need to be asked are atleast manage_pages and read_insights.

#### List all accounts/pages where the user has the CREATE_CONTENT permission.
```
FacebookInsights::User.new(@access_token).accounts
```

#### List general information about a page
```
FacebookInsights::User.new(@access_token).account(@account_id)
```

#### Get the latest likes of a page
```
FacebookInsights::User.new(@access_token).reach(id, since_date=Date.parse("2015-04-08"), until_dateDate.parse("2015-04-09"))
```

#### Get the gender distribution of likes of a page
```
FacebookInsights::User.new(@access_token).gender_distribution(id, since_date=Date.parse("2015-04-08"), until_dateDate.parse("2015-04-09"))
```

#### Get the country distribution of likes of a page
```
FacebookInsights::User.new(@access_token).country_distribution(id, since_date=Date.parse("2015-04-08"), until_dateDate.parse("2015-04-09"))
```

#### Get the latest posts of a page
```
FacebookInsights::User.new(@access_token).posts(id)
```
