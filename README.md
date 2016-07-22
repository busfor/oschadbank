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
  merchant_gmt: '+3',
  country_code: 'UA',
  email: 'mail@my-shop.com',
)
```

Then you can get request url and request params for payments:

```ruby
url = client.api_url
# => "https://3ds.oschadnybank.com/cgi-bin/cgi_link/"

params = client.pre_auth_params(
  order_id: 123456,
  currency: 'UAH',
  amount: 100.5,
  description: 'Payment description',
  back_url: 'http://www.my-shop.com/back/url',
)
# => {:TRTYPE=>"0",
#  :TERMINAL=>"123",
#  :MERCHANT=>"456",
#  :MERCH_NAME=>"Shop name",
#  :MERCH_URL=>"www.my-shop.com",
#  :MERCH_GMT=>"+3",
#  :COUNTRY=>"UA",
#  :EMAIL=>"example@my-shop.com",
#  :TIMESTAMP=>"20160718093533",
#  :NONCE=>"c82f595aef2ead17103c806b701e994c",
#  :ORDER=>"123456",
#  :CURRENCY=>"UAH",
#  :AMOUNT=>"100.5",
#  :DESC=>"Payment description",
#  :BACKREF=>"http://www.my-shop.com/back/link",
#  :P_SIGN=>"040a2920ec647e901756349491bb0167fa184747"}

params = client.auth_params(
  order_id: 123456,
  currency: 'UAH',
  amount: 100.5,
  description: 'Payment description',
  back_url: 'http://www.my-shop.com/back/url',
)
# => {:TRTYPE=>"1",
#  :TERMINAL=>"123",
#  :MERCHANT=>"456",
#  :MERCH_NAME=>"Shop name",
#  :MERCH_URL=>"www.my-shop.com",
#  :MERCH_GMT=>"+3",
#  :COUNTRY=>"UA",
#  :EMAIL=>"example@my-shop.com",
#  :TIMESTAMP=>"20160718093707",
#  :NONCE=>"4a6de0a53f759469042ce3fb08accb13",
#  :ORDER=>"123456",
#  :CURRENCY=>"UAH",
#  :AMOUNT=>"100.5",
#  :DESC=>"Payment description",
#  :BACKREF=>"http://www.my-shop.com/back/link",
#  :P_SIGN=>"73e7a49bf4b729f5c66c160117e05d6b1f3a1f3e"}
```

To complete payment after pre-authorization request:

```ruby
client.charge(
  order_id: 123456,
  currency: 'UAH',
  amount: 100.5,
  rrn: 111,
  int_ref: 222,
  back_url: 'http://www.my-shop.com/back/url',
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
  back_url: 'http://www.my-shop.com/back/url',
)
```

Also you can check response from Oschadbank:

```ruby
response = client.response(
  'Function' => 'TransResponse',
  'Result' => '0',
  'RC' => '00',
  'Amount' => '100.50',
  'Currency' => 'UAH',
  'Order' => '123456',
  'RRN' => '111',
  'IntRef' => '222',
  'AuthCode' => '333',
  'TRTYPE' => '1',
)

response.request_type   # => :auth
response.pre_auth?      # => false
response.auth?          # => true
response.charge?        # => false
response.refund?        # => false

response.success?       # => true
response.status_code    # => "00"
response.status_message # => "Transaction successfully completed (Approved)"

response.order_id       # => "123456"
response.currency       # => "UAH"
response.amount         # => 100.5

response.rrn            # => "111"
response.int_ref        # => "222"
response.auth_code      # => "333"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/busfor/oschadbank. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
