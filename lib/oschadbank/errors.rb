module Oschadbank
  class Error < StandardError
  end

  class InvalidRequestType < Error
  end

  class RequestError < Error
  end

  class InvalidResponse < Error
  end
end
