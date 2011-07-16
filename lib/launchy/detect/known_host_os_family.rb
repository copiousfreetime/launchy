module Launchy::Detect
  class HostOsFamily
    #
    # Every class that inherits from Known must define:
    #
    # 1. A class method 'matching_regex' returning a regex that will match
    #    those host_os strings that are in the family
    #
 
    class Known < HostOsFamily
      extend ::Launchy::DescendantTracker

      class << self
        def matches?( host_os )
          matching_regex.match( host_os.to_s )
        end

        def detect( host_os = Launchy.host_os )
          klass = children.find do |klass|
            Launchy.log( "Seeing if #{klass.name} matches host_os '#{host_os}'" )
            klass.matches?( host_os )
          end

          if klass then
            Launchy.log( "#{klass.name} matches '#{host_os}'" )
            return klass
          end
          $stderr.puts "Unknown OS family for '#{host_os}'. #{Launchy.bug_report_message}"
          return HostOsFamily::Unknown
        end
      end
    end

    class Windows < Known
      def self.matching_regex
        /(mingw|mswin|windows)/i
      end
    end

    class Darwin < Known
      def self.matching_regex
        /(darwin|mac os)/i
      end
    end

    class Nix < Known
      def self.matching_regex
        /(linux|bsd|aix|solaris)/i
      end
    end

    class Cygwin < Known
      def self.matching_regex
        /cygwin/i
      end
    end
  end
end
