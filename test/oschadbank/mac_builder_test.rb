require 'test_helper'

module Oschadbank
  class MacBuilderTest < MiniTest::Test
    def test_it_builds_mac
      request_params = {
        'AMOUNT' => 11.48,
        'BACKREF' => 'https://www.sample.com/shop/reply',
        'CURRENCY' => 'UAH',
        'DESC' => 'IT Books. Qty: 2',
        'EMAIL' => 'pgw@mail.sample.com',
        'MERCH_NAME' => 'Books Online Inc.',
        'MERCH_URL' => 'www.sample.com',
        'MERCHANT' => 'oschad3DSW0000001',
        'NONCE' => 'F2B2DD7E603A7ADA',
        'ORDER' => '771446',
        'TERMINAL' => 'W0000001',
        'TRTYPE' => '0',
        'TIMESTAMP' => '20030105153021',
      }
      mac_key = '00112233445566778899AABBCCDDEEFF'

      expected_mac = '5e0604f20d4f4d9e1ee08ec18ddee212f3fcb9f0'
      mac = MacBuilder.new(:auth, mac_key, request_params).build

      assert_equal expected_mac, mac
    end
  end
end
