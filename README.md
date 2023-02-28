# PayWithExtend

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/pay_with_extend`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pay_with_extend'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pay_with_extend

## Usage

Configure Extend in config/initializers/pay_with_extend.rb

```
PayWithExtend.configure do |config|
  config.environment = "production"
  config.account_email = "account email goes here"
  config.account_password = "account password goes here"
  config.api_version = "application/vnd.paywithextend.v2021-03-12+json"
end
```

Create pay_with_extend client in config/initializers/pay_with_extend.rb

```
$extend_client = PayWithExtend::Client.new
```

Refresh token if needed

```
$extend_client.refresh_token
```

Get Virtual Credit Card

```
$extend_client.get_virtual_card(
  { "card_id_xxxxxx" }
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/metaware/pay_with_extend.
