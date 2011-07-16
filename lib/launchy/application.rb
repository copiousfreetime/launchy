require 'set'
module Launchy
  #
  # Application is the base class of all the application types that launchy may
  # invoke. It essentially defines the public api of the launchy system.
  #
  # Every class that inherits from Application must define:
  #
  # 1. A constructor taking no parameters
  # 2. An instance method 'open' taking a string or URI as the first parameter and a
  #    hash as the second
  # 3. A class method 'schemes' that returns an array of Strings containing the
  #    schemes that the Application will handle
  class Application
    extend DescendantTracker

    class << self
      #
      # The list of all the schems all the applications now
      #
      def scheme_list
        children.collect { |a| a.schemes }.flatten.sort
      end

      #
      # if this application handles the given scheme
      #
      def handles?( scheme )
        schemes.include?( scheme )
      end

      #
      # Find the application that handles the given scheme.  May take either a
      # String or something that responds_to?( :scheme )
      #
      def for_scheme( scheme )
        if scheme.respond_to?( :scheme ) then
          scheme = scheme.scheme
        end

        klass = children.find do |klass|
          Launchy.log( "Seeing if #{klass.name} handles scheme #{scheme}" )
          klass.handles?( scheme )
        end

        if klass then
          Launchy.log( "#{klass.name} handles #{scheme}" )
          return klass
        end

        raise SchemeNotFoundError, "No application found to handle scheme '#{scheme}'. Known schemes: #{scheme_list.join(", ")}"
      end
    end

  end
end
