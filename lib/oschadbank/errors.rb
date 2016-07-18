module Oschadbank
  class Error < StandardError
  end

  class InvalidRequestType < Error
    def initialize
      super('Invalid request type')
    end
  end

  class RequestError < Error
  end

  class InvalidResponse < Error
  end
end
