require 'rbconfig'

module Launchy
  class DetectHostOs

    attr_reader :raw_host_os

    def initialize( host_os = nil )
      @raw_host_os = host_os

      if not @raw_host_os then
        if @raw_host_os = override_host_os then
          Launchy.log "Using LAUNCHY_HOST_OS override value of '#{ENV['LAUNCHY_HOST_OS']}'"
        else
          @raw_host_os = default_host_os
        end
      end
    end

    def default_host_os
      ::RbConfig::CONFIG['host_os']
    end

    def override_host_os
      ENV['LAUNCHY_HOST_OS']
    end

  end

end
