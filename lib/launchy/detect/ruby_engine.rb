module Launchy::Detect
  class RubyEngine
    # Detect the current ruby engine.
    #
    # If the current ruby engine cannot be detected, the return
    # RubyEngine::Unknown
    def self.detect( ruby_engine = Launchy.ruby_engine )
      found = RubyEngine::Known.detect( ruby_engine )
      return found if found

      if ruby_engine then
        $stderr.puts "Unknown RUBY_ENGINE '#{ruby_engine}'. #{Launchy.bug_report_message}"
      elsif defined?( RUBY_ENGINE ) then
        $stderr.puts "Unknown RUBY_ENGINE '#{RUBY_ENGINE}'. #{Launchy.bug_report_message}"
      else
        $stderr.puts "RUBY_ENGINE not defined for #{RUBY_DESCRIPTION}. #{Launchy.bug_report_message}"
      end
      return RubyEngine::Unknown
    end

    class Unknown < RubyEngine; 
      def self.engine_name() "unknown"; end
    end

  end
end
