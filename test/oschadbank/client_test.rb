require 'test_helper'

module Oschadbank
  class ClientTest < MiniTest::Test
    def setup
      @client = Client.new(
        mac_key: '00112233445566778899AABBCCDDEEFF',
        terminal_id: 123,
        merchant_id: 456,
        merchant_name: 'Shop name',
        merchant_url: 'www.my-shop.com',
        merchant_gmt: '+3',
        country_code: 'UA',
        email: 'mail@my-shop.com',
      )
    end

    def test_initial_attrs
      assert_equal 'https://3ds.oschadnybank.com/cgi-bin/cgi_link/', @client.api_url
      assert_equal '00112233445566778899AABBCCDDEEFF', @client.mac_key
      assert_equal 123, @client.terminal_id
      assert_equal 456, @client.merchant_id
      assert_equal 'Shop name', @client.merchant_name
      assert_equal 'www.my-shop.com', @client.merchant_url
      assert_equal '+3', @client.merchant_gmt
      assert_equal 'UA', @client.country_code
      assert_equal 'mail@my-shop.com', @client.email
    end
  end
end
