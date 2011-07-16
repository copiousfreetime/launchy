module Launchy::Detect
  # Detect the current host os family
  #
  # If the current host familiy cannot be detected then return
  # HostOsFamily::Unknown
  class HostOsFamily
    class NotFoundError < Launchy::Error; end
    extend ::Launchy::DescendantTracker

    def self.detect( host_os = Launchy.host_os )
      found = find_child( :matches?, host_os )
      return found if found
      raise NotFoundError, "Unknown OS family for host os '#{host_os}'. #{Launchy.bug_report_message}"
    end

    def self.matches?( host_os )
      matching_regex.match( host_os.to_s )
    end

    #---------------------------
    # All known host os families
    #---------------------------
    #
    class Windows < HostOsFamily
      def self.matching_regex
        /(mingw|mswin|windows)/i
      end
    end

    class Darwin < HostOsFamily
      def self.matching_regex
        /(darwin|mac os)/i
      end
    end

    class Nix < HostOsFamily
      def self.matching_regex
        /(linux|bsd|aix|solaris)/i
      end
    end

    class Cygwin < HostOsFamily
      def self.matching_regex
        /cygwin/i
      end
    end

  end
end
