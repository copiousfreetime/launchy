module Launchy::Detect
  class RubyEngine
    class NotFoundError < Launchy::Error; end

    extend ::Launchy::DescendantTracker

    # Detect the current ruby engine.
    #
    # If the current ruby engine cannot be detected, the return
    # RubyEngine::Unknown
    def self.detect( ruby_engine = Launchy.ruby_engine )
      found = find_child_class_for_engine( ruby_engine )
      return found if found

      msg = "Unkonwn RUBY_ENGINE "
      if ruby_engine then
        msg += " '#{ruby_engine}'."
      elsif defined?( RUBY_ENGINE ) then
        msg += " '#{RUBY_ENGINE}'."
      else
        msg = "RUBY_ENGINE not defined for #{RUBY_DESCRIPTION}."
      end

      raise NotFoundError, "#{msg} #{Launchy.bug_report_message}"
    end

    def self.is_current_engine?( ruby_engine )
      return ruby_engine == self.engine_name
    end


    # search through the descendent classes looking for the one that says it
    # is the current ruby engine
    def self.find_child_class_for_engine( ruby_engine )
      klass = children.find do |klass|
        Launchy.log( "Seeing if #{klass.name} is the current ruby engine" )
        klass.is_current_engine?( ruby_engine )
      end

      if klass then
        Launchy.log( "#{klass.name} is the current ruby engine" )
        return klass
      end

      return nil
    end

    #-------------------------------
    # The list of known ruby engines
    #-------------------------------

    #
    # This is the ruby engine if the RUBY_ENGINE constant is not defined
    class Mri < RubyEngine
      def self.engine_name() "ruby"; end
      def self.is_current_engine?( ruby_engine )
        if ruby_engine then
          super( ruby_engine )
        else
          return true if not Launchy.ruby_engine and not defined?( RUBY_ENGINE )
        end
      end
    end

    class Jruby < RubyEngine
      def self.engine_name() "jruby"; end
    end

    class Rbx < RubyEngine
      def self.engine_name() "rbx"; end
    end

    class MacRuby < RubyEngine
      def self.engine_name() "macruby"; end
    end
  end
end
