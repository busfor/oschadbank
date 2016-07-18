module Oschadbank
  class Client
    extend Dry::Initializer::Mixin

    option :mac_key
    option :terminal_id
    option :merchant_id
    option :merchant_name
    option :merchant_url
    option :merchant_gmt, default: proc { nil }
    option :country_code, default: proc { nil }
    option :email, default: proc { nil }

    def request_url
      'https://3ds.oschadnybank.com/cgi-bin/cgi_link/'
    end

    def pre_authorization_request_params(args)
      ParamsBuilder.new(self, :pre_authorization, args).build
    end

    def authorization_request_params(args)
      ParamsBuilder.new(self, :authorization, args).build
    end

    def complete_payment(args)
      request_params = ParamsBuilder.new(self, :complete, args).build
      Request.new(request_url, request_params).perform
    end

    def refund_payment(args)
      request_params = ParamsBuilder.new(self, :refund, args).build
      Request.new(request_url, request_params).perform
    end
  end
end
