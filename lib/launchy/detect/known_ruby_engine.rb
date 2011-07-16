module Launchy::Detect
  class RubyEngine
    #
    # Every class that inherits from Known must define:
    #
    # 1. A class method 'is_current_engine?' that returns true if 
    #    the current ruby intrepreter is that engine
    #
 
    class Known < RubyEngine
      extend ::Launchy::DescendantTracker

      class << self
        def detect( ruby_engine = Launchy.ruby_engine )
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

        def is_current_engine?( ruby_engine )
          return ruby_engine == self.engine_name
        end
      end
    end

    #
    # This is the ruby engine if the RUBY_ENGINE constant is not defined
    class Mri < Known
      def self.engine_name() "ruby"; end
      def self.is_current_engine?( ruby_engine )
        if ruby_engine then
          super( ruby_engine )
        else
          return true if not Launchy.ruby_engine and not defined?( RUBY_ENGINE )
        end
      end
    end

    class Jruby < Known
      def self.engine_name() "jruby"; end
    end

    class Rbx < Known
      def self.engine_name() "rbx"; end
    end

    class MacRuby < Known
      def self.engine_name() "macruby"; end
    end
  end
end

