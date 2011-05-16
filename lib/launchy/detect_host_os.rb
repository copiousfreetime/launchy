require 'rbconfig'

module Launchy
  class DetectHostOs

    attr_reader :raw_host_os

    def initialize( host_os = ENV['LAUNCHY_HOST_OS'] || Config::CONFIG['host_os'] )
      @raw_host_os = host_os
    end
  end
end
