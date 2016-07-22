require 'test_helper'

module Oschadbank
  class ResponseTest < MiniTest::Test
    def setup
      @client = Minitest::Mock.new
      @client.expect :mac_key, '00112233445566778899AABBCCDDEEFF'
    end

    def test_it_process_auth_response_params
      response = Response.new(@client,
        'Function' => 'TransResponse',
        'Result' => '0',
        'RC' => '00',
        'Amount' => '20.00',
        'Currency' => 'UAH',
        'Order' => '123',
        'RRN' => '456',
        'IntRef' => '1234567890',
        'AuthCode' => '321',
        'TRTYPE' => '1',
        'P_SIGN' => 'ffff', # TODO
      )

      assert_equal :auth, response.request_type
      assert_equal false, response.pre_auth?
      assert_equal true, response.auth?
      assert_equal false, response.charge?
      assert_equal false, response.refund?

      assert_equal true, response.success?
      assert_equal '00', response.status_code
      assert_equal 'Transaction successfully completed (Approved)', response.status_message

      assert_equal '123', response.order_id
      assert_equal 'UAH', response.currency
      assert_equal 20.0, response.amount
      assert_equal '456', response.rrn
      assert_equal '1234567890', response.int_ref
      assert_equal '321', response.auth_code
    end

    def test_it_process_error_response_params
      response = Response.new(@client,
        'Function' => 'TransResponse',
        'Result' => '3',
        'RC' => '55',
        'Amount' => '20.00',
        'Currency' => 'UAH',
        'Order' => '123',
        'TRTYPE' => '0',
        'P_SIGN' => 'ffff', # TODO
      )

      assert_equal true, response.pre_auth?

      assert_equal false, response.success?
      assert_equal '55', response.status_code
      assert_equal 'Transaction processing fault (Incorrect PIN)', response.status_message

      assert_nil response.rrn
      assert_nil response.int_ref
    end

    def test_it_require_params
      valid_params = {
        'Result' => '0',
        'RC' => '00',
        'Order' => '123',
        'TRTYPE' => '0',
        'P_SIGN' => 'ffff', # TODO
      }
      params_without_result = {
        'RC' => '00',
        'Order' => '123',
        'TRTYPE' => '0',
        'P_SIGN' => 'ffff', # TODO
      }
      params_without_rc = {
        'Result' => '0',
        'Order' => '123',
        'TRTYPE' => '0',
        'P_SIGN' => 'ffff', # TODO
      }
      params_without_order = {
        'Result' => '0',
        'RC' => '00',
        'TRTYPE' => '0',
        'P_SIGN' => 'ffff', # TODO
      }
      params_without_tr_type = {
        'Result' => '0',
        'RC' => '00',
        'Order' => '123',
        'P_SIGN' => 'ffff', # TODO
      }
      params_without_p_sign = {
        'Result' => '0',
        'RC' => '00',
        'Order' => '123',
        'TRTYPE' => '0',
      }

      response = Response.new(@client, valid_params) # not raise
      assert_raises(ParamRequred) { Response.new(@client, params_without_result) }
      assert_raises(ParamRequred) { Response.new(@client, params_without_rc) }
      assert_raises(ParamRequred) { Response.new(@client, params_without_order) }
      assert_raises(ParamRequred) { Response.new(@client, params_without_tr_type) }
      assert_raises(ParamRequred) { Response.new(@client, params_without_p_sign) }
    end

    def test_it_check_signature
      params_with_invalid_p_sign = {
        'Result' => '0',
        'RC' => '00',
        'Order' => '123',
        'TRTYPE' => '0',
        'P_SIGN' => 'invalid',
      }
      assert_raises(InvalidSignature) { Response.new(@client, params_with_invalid_p_sign) }
    end
  end
end
