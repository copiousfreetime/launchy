module Launchy
  class Error < ::StandardError; end
  class ApplicationNotFoundError < Error; end
  class CommandNotFoundError < Error; end
end
