
module Launchy::Detect
  class HostOsFamily
    class Unknown; end

    attr_reader :host_os_family

    def initialize( host_os = HostOs.new )
      host_os = HostOs.new( host_os ) if host_os.kind_of?( String )
      @host_os_family = detect( host_os )
    end

    def detect( host_os )
      Known.detect( host_os )
    end
  end

end
