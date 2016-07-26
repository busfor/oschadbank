module Oschadbank
  class ParamsBuilder
    include Constants

    REQUEST_PARAMS = {
      amount: 'AMOUNT',
      org_amount: 'ORG_AMOUNT',
      currency: 'CURRENCY',
      order_id: 'ORDER',
      description: 'DESC',
      rrn: 'RRN',
      int_ref: 'INT_REF',
      back_url: 'BACKREF',
    }.freeze

    def initialize(client, request_type, params)
      @client = client
      @request_type = request_type
      @params = params
    end

    def build
      result = {
        'TRTYPE' => tr_type,
        'TERMINAL' => @client.terminal_id.to_s,
        'MERCHANT' => @client.merchant_id.to_s,
        'MERCH_NAME' => @client.merchant_name.to_s,
        'MERCH_URL' => @client.merchant_url.to_s,
        'MERCH_GMT' => @client.merchant_gmt.to_s,
        'COUNTRY' => @client.country_code.to_s,
        'EMAIL' => @client.email.to_s,
        'TIMESTAMP' => timestamp,
        'NONCE' => nonce,
      }

      @params.each do |key, value|
        key = REQUEST_PARAMS[key] || key
        value = value.to_s
        value = value.encode('CP1251', 'UTF-8') if key == 'DESC'
        value = value.rjust(6, '0') if key == 'ORDER'
        value = '%.2f' % value if %w(AMOUNT ORG_AMOUNT).include?(key)
        result[key] = value
      end

      result.delete_if { |_k, v| v.empty? }

      result['P_SIGN'] = mac_signature(result)

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
