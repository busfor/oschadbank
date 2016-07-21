module Oschadbank
  class Error < StandardError
  end

  class InvalidRequestType < Error
  end

  class RequestError < Error
  end

  class InvalidResponse < Error
  end

  class ParamRequred < Error
    def initialize(param)
      super("Param #{param} required")
    end
  end
end
