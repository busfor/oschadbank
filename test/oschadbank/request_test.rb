require 'test_helper'

module Oschadbank
  class RequestTest < MiniTest::Test
    def setup
      @request_url = 'https://3ds.oschadnybank.com/cgi-bin/cgi_link/'
      @request_params = {
        ORDER: '123',
        AMOUNT: '100.5',
        CURRENCY: 'UAH',
      }
      @request_body = 'AMOUNT=100.5&CURRENCY=UAH&ORDER=123'
    end

    def test_it_make_http_request
      stub_post =
        stub_request(:post, @request_url)
          .with(body: @request_body)
          .to_return(status: 200)

      Request.new(@request_url, @request_params).perform

      assert_requested(stub_post)
    end

    def test_it_raise_error_when_request_failed
      stub_request(:post, @request_url)
        .with(body: @request_body)
        .to_return(status: 403)

      request = Request.new(@request_url, @request_params)

      assert_raises(InvalidResponse) { request.perform }
    end

    def test_it_raise_error_when_request_timeouted
      stub_request(:post, @request_url)
        .with(body: @request_body)
        .to_timeout

      request = Request.new(@request_url, @request_params)

      assert_raises(RequestError) { request.perform }
    end
  end
end
