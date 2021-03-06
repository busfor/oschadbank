module Oschadbank
  class Error < StandardError
  end

  class InvalidRequestType < Error
  end

  class RequestError < Error
  end

  class InvalidResponse < Error
  end

  class ParamRequired < Error
    def initialize(param)
      super("Param #{param} required")
    end
  end

  class InvalidSignature < Error
    def initialize
      super("Invalid signature param")
    end
  end
end
