module Oschadbank
  class Client
    extend Dry::Initializer::Mixin

    DEFAULT_API_URL = 'https://3ds.oschadnybank.com/cgi-bin/cgi_link/'

    option :api_url, default: proc { DEFAULT_API_URL }
    option :mac_key
    option :terminal_id
    option :merchant_id
    option :merchant_name
    option :merchant_url
    option :merchant_gmt
    option :country_code
    option :email, default: proc { nil }

    def pre_auth_params(args)
      ParamsBuilder.new(self, :pre_authorization, args).build
    end

    def auth_params(args)
      ParamsBuilder.new(self, :authorization, args).build
    end

    def charge(args)
      request_params = ParamsBuilder.new(self, :complete, args).build
      Request.new(api_url, request_params).perform
    end

    def refund(args)
      request_params = ParamsBuilder.new(self, :refund, args).build
      Request.new(api_url, request_params).perform
    end
  end
end
