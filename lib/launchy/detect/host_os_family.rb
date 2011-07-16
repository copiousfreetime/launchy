module Launchy::Detect
  # Detect the current host os family
  #
  # If the current host familiy cannot be detected then return
  # HostOsFamily::Unknown
  class HostOsFamily

    def self.detect( host_os = Launchy.host_os )
      found = HostOsFamily::Known.detect( host_os )
      return found if found
      $stderr.puts "Unknown OS family for host os '#{host_os}'. #{Launchy.bug_report_message}"
    end

    class Unknown < HostOsFamily
      def self.family_name() " unknown"; end
    end
  end

end
