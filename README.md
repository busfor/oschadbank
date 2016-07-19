# Oschadbank

Ruby wrapper for Oschadbank.ua API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oschadbank'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oschadbank

## Usage

First, you need to initialize client:

```ruby
client = Oschadbank::Client.new(
  mac_key: '00112233445566778899AABBCCDDEEFF',
  terminal_id: 123,
  merchant_id: 456,
  merchant_name: 'Shop name',
  merchant_url: 'www.my-shop.com',
)
```

Then you can send PreAuthorization or Authorization request:

```ruby
client.pre_authorize(
  order_id: 123456,
  currency: 'UAH',
  amount: 100.5,
  description: 'Payment description',
  back_link: 'http://www.my-shop.com/back/link',
)

client.authorize(
  order_id: 123456,
  currency: 'UAH',
  amount: 100.5,
  description: 'Payment description',
  back_link: 'http://www.my-shop.com/back/link',
)
```

To complete payment after PreAuthorization request:

```ruby
client.complete(
  order_id: 123456,
  currency: 'UAH',
  amount: 100.5,
  rrn: 111,
  int_ref: 222,
  back_link: 'http://www.my-shop.com/back/link',
)
```

To perform a refund:

```ruby
client.refund(
  order_id: 123456,
  currency: 'UAH',
  org_amount: 100.5,
  amount: 90,
  rrn: 111,
  int_ref: 222,
  back_link: 'http://www.my-shop.com/back/link',
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/busfor/oschadbank. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
