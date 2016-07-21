module Oschadbank
  class Response
    include Constants

    def initialize(params)
      @params = params

      check_required!
    end

    def request_type
      TR_TYPE.invert[@params['TRTYPE'].to_s]
    end

    def pre_auth?
      request_type == :pre_auth
    end

    def auth?
      request_type == :auth
    end

    def charge?
      request_type == :charge
    end

    def refund?
      request_type == :refund
    end

    def success?
      RESULT_SUCCESS.include?(result_code) && RC_SUCCESS.include?(rc_code)
    end

    def status_code
      rc_code
    end

    def status_message
      "#{result_message} (#{rc_message})"
    end

    def order_id
      @params['Order']
    end

    def currency
      @params['Currency']
    end

    def amount
      @params['Amount'] && @params['Amount'].to_f
    end

    def rrn
      @params['RRN']
    end

    def int_ref
      @params['IntRef']
    end

    def auth_code
      @params['AuthCode']
    end

    private

    def check_required!
      required_params = ['Order', 'Result', 'RC', 'TRTYPE']
      required_params.each do |param|
        raise ParamRequred.new(param) if @params[param].to_s.empty?
      end
    end

    def result_code
      @params['Result'].to_s
    end

    def rc_code
      @params['RC'].to_s
    end

    def result_message
      RESULT_MESSAGES[result_code]
    end

    def rc_message
      RC_MESSAGES[rc_code]
    end
  end
end
