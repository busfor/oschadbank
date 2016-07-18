module Oschadbank
  class PaymentRefund < MakeRequest
    private

    def request_type
      :refund
    end
  end
end
