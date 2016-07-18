module Oschadbank
  class PaymentComplete < MakeRequest
    private

    def request_type
      :complete
    end
  end
end
