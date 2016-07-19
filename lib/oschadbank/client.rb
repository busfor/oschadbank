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
    option :merchant_gmt, default: proc { nil }
    option :country_code, default: proc { nil }
    option :email, default: proc { nil }

    def pre_authorize(args)
      request_params = ParamsBuilder.new(self, :pre_authorization, args).build
      Request.new(api_url, request_params).perform
    end

    def authorize(args)
      request_params = ParamsBuilder.new(self, :authorization, args).build
      Request.new(api_url, request_params).perform
    end

    def complete(args)
      request_params = ParamsBuilder.new(self, :complete, args).build
      Request.new(api_url, request_params).perform
    end

    def refund(args)
      request_params = ParamsBuilder.new(self, :refund, args).build
      Request.new(api_url, request_params).perform
    end
  end
end
