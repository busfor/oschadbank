module Oschadbank
  class ParamsBuilder
    REQUEST_PARAMS = {
      amount: :AMOUNT,
      org_amount: :ORG_AMOUNT,
      currency: :CURRENCY,
      order_id: :ORDER,
      description: :DESC,
      rrn: :RRN,
      int_ref: :INT_REF,
      back_link: :BACKREF,
    }.freeze

    TR_TYPE = {
      pre_authorization: '0',
      authorization: '1',
      complete: '21',
      refund: '24',
    }.freeze

    def initialize(client, request_type, params)
      @client = client
      @request_type = request_type
      @params = params
    end

    def build
      result = {
        TRTYPE: tr_type,
        TERMINAL: @client.terminal_id.to_s,
        MERCHANT: @client.merchant_id.to_s,
        MERCH_NAME: @client.merchant_name.to_s,
        MERCH_URL: @client.merchant_url.to_s,
        MERCH_GMT: @client.merchant_gmt.to_s,
        COUNTRY: @client.country_code.to_s,
        EMAIL: @client.email.to_s,
        TIMESTAMP: timestamp,
        NONCE: nonce,
      }

      @params.each do |key, value|
        key = REQUEST_PARAMS[key] || key
        result[key] = value.to_s
      end

      result.delete_if { |_k, v| v.empty? }

      result[:P_SIGN] = mac_signature(result)

      result
    end

    private

    def tr_type
      TR_TYPE[@request_type] || raise(InvalidRequestType)
    end

    def timestamp
      Time.now.gmtime.strftime('%Y%m%d%H%M%S')
    end

    # Random HEX value, with length between 8 and 32
    def nonce
      min = 0xFFFFFFFF
      max = 0XFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      value = rand(max - min) + min
      value.to_s(16)
    end

    def mac_signature(params)
      MacBuilder.new(@request_type, @client.mac_key, params).build
    end
  end
end
