module Oschadbank
  class MacBuilder
    include Constants

    def initialize(request_type, mac_key, request_params)
      @request_type = request_type
      @mac_key = mac_key
      @request_params = request_params

      @request_type = :auth if @request_type == :pre_auth
    end

    def build
      params_order = MAC_PARAMS_ORDER[@request_type]
      return unless params_order

      params_str = join_params(@request_params, params_order)

      digest = OpenSSL::Digest.new('sha1')
      OpenSSL::HMAC.hexdigest(digest, packed_key, params_str)
    end

    private

    def packed_key
      [@mac_key].pack('H*')
    end

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
