require 'test_helper'

module Oschadbank
  class ParamsBuilderTest < MiniTest::Test
    def setup
      @client = Minitest::Mock.new
      @client.expect :mac_key, '00112233445566778899AABBCCDDEEFF'
      @client.expect :terminal_id, 'W0000001'
      @client.expect :merchant_id, 'oschad3DSW0000001'
      @client.expect :merchant_name, 'Books Online Inc.'
      @client.expect :merchant_url, 'www.sample.com'
      @client.expect :merchant_gmt, nil
      @client.expect :country_code, nil
      @client.expect :email, 'pgw@mail.sample.com'

      @args = {
        order_id: 771446,
        currency: 'UAH',
        amount: 11.48,
        description: 'IT Books. Qty: 2',
        back_link: 'https://www.sample.com/shop/reply',
      }
    end

    def test_it_build_params_from_client
      params = ParamsBuilder.new(@client, :pre_authorization, @args).build

      assert_equal 'W0000001', params[:TERMINAL]
      assert_equal 'oschad3DSW0000001', params[:MERCHANT]
      assert_equal 'Books Online Inc.', params[:MERCH_NAME]
      assert_equal 'www.sample.com', params[:MERCH_URL]
      assert_equal 'pgw@mail.sample.com', params[:EMAIL]
    end

    def test_it_build_params_from_args
      params = ParamsBuilder.new(@client, :pre_authorization, @args).build

      assert_equal '771446', params[:ORDER]
      assert_equal 'UAH', params[:CURRENCY]
      assert_equal '11.48', params[:AMOUNT]
      assert_equal 'IT Books. Qty: 2', params[:DESC]
      assert_equal 'https://www.sample.com/shop/reply', params[:BACKREF]
    end

    def test_it_generate_nonce
      params = ParamsBuilder.new(@client, :pre_authorization, @args).build

      assert_includes 8..32, params[:NONCE].length
    end

    def test_it_set_current_timestamp
      params =
        Time.stub(:now, Time.gm(2003, 1, 5, 15, 30, 21)) do
          ParamsBuilder.new(@client, :pre_authorization, @args).build
        end

      assert_equal '20030105153021', params[:TIMESTAMP]
    end

    def test_it_generate_mac
      mac_builder = Minitest::Mock.new
      mac_builder.expect :build, 'fa8345c0f2b5c6406878b9cf4d8db723f1ddf9cc'

      params =
        MacBuilder.stub(:new, mac_builder) do
          ParamsBuilder.new(@client, :pre_authorization, @args).build
        end

      assert_equal 'fa8345c0f2b5c6406878b9cf4d8db723f1ddf9cc', params[:P_SIGN]
    end

    def test_it_raise_error_for_invalid_request_type
      params_builder = ParamsBuilder.new(@client, :invalid, @args)

      assert_raises(InvalidRequestType) { params_builder.build }
    end
  end
end
