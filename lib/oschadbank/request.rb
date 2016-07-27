module Oschadbank
  class Request
    extend Dry::Initializer::Mixin

    param :request_url
    param :request_params

    def perform
      response = make_request

      unless response.status == 200
        raise InvalidResponse, "Response status: #{response.status}"
      end

      response
    end

    private

    def make_request
      connection = Faraday::Connection.new(request_url, ssl: {
        ca_file: cert_file,
      })
      connection.post(request_url, request_params)
    rescue Faraday::Error => e
      raise RequestError, e.message
    end

    def cert_file
      File.expand_path("../../data/cert.pem", File.dirname(__FILE__))
    end
  end
end
