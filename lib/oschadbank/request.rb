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
      Faraday.post(request_url, request_params)
    rescue Faraday::Error => e
      raise RequestError, e.message
    end
  end
end
