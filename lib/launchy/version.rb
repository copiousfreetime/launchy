module Launchy
  VERSION = "3.0.0"

  module Version

    MAJOR   = Integer(VERSION.split('.')[0])
    MINOR   = Integer(VERSION.split('.')[1])
    PATCH   = Integer(VERSION.split('.')[2])

    def self.to_a
      [MAJOR, MINOR, PATCH]
    end

    def self.to_s
      VERSION
    end
  end
end
