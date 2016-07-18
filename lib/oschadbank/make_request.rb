module Oschadbank
  class MakeRequest    
    def initialize(client, request_url, params)
      @client = client
      @request_url = request_url
      @params = params
    end

    def perform
      request_params = ParamsBuilder.new(@client, request_type, @params).build

      make_request(@request_url, request_params)
    end

    private

    def request_type
      raise 'Not implemented'
    end

    def make_request(url, params)
      response = connection.post(url, params)

      unless response.status == 200
        raise InvalidResponse, "Response status: #{response.status}"
      end

      response
    end

    def connection
      Faraday.new do |faraday|
        faraday.request :url_encoded
      end
    end
  end
end
