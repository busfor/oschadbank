module Oschadbank
  class Error < StandardError
  end

  class InvalidRequestType < Error
    def initialize
      super('Invalid request type')
    end
  end
end
