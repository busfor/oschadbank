module Oschadbank
  class MacBuilder
    PARAMS_ORDER = {
      authorization: [
        :AMOUNT,
        :CURRENCY,
        :ORDER,
        :DESC,
        :MERCH_NAME,
        :MERCH_URL,
        :MERCHANT,
        :TERMINAL,
        :EMAIL,
        :TRTYPE,
        :COUNTRY,
        :MERCH_GMT,
        :TIMESTAMP,
        :NONCE,
        :BACKREF,
      ].freeze,
      complete: [
        :ORDER,
        :AMOUNT,
        :CURRENCY,
        :RRN,
        :INT_REF,
        :TRTYPE,
        :TERMINAL,
        :BACKREF,
        :TIMESTAMP,
        :NONCE,
      ].freeze,
      refund: [
        :ORDER,
        :ORG_AMOUNT,
        :AMOUNT,
        :CURRENCY,
        :RRN,
        :INT_REF,
        :TRTYPE,
        :TERMINAL,
        :BACKREF,
        :TIMESTAMP,
        :NONCE,
      ].freeze,
    }.freeze

    def initialize(request_type, mac_key, request_params)
      @request_type = request_type
      @mac_key = mac_key
      @request_params = request_params
    end

    def build
      params_order = PARAMS_ORDER[@request_type]
      return unless params_order

      params_str = join_params(@request_params, params_order)

      digest = OpenSSL::Digest.new('sha1')
      OpenSSL::HMAC.hexdigest(digest, @mac_key, params_str)
    end

    private

    def join_params(params, params_order)
      parts = params_order.map do |param|
        value = params[param].to_s
        if value.empty?
          '-'
        else
          "#{value.length}#{value}"
        end
      end

      parts.join
    end
  end
end
