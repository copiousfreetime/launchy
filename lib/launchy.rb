module Launchy
  class << self
    #
    # Convenience method to launch an item
    #
    def open(*params)
      begin
        klass = Launchy::Application.find_application_class_for(*params)
        if klass then
          klass.run(*params)
        else
          msg = "Unable to launch #{params.join(' ')}"
          Launchy.log "#{self.name} : #{msg}"
          $stderr.puts msg
        end
      rescue Exception => e
        msg = "Failure in opening #{params.join(' ')} : #{e}"
        Launchy.log "#{self.name} : #{msg}"
        $stderr.puts msg
      end
    end

    # Setting the LAUNCHY_DEBUG environment variable to 'true' will spew
    # debug information to $stderr
    def log(msg)
      if ENV['LAUNCHY_DEBUG'] == 'true' then
        $stderr.puts "LAUNCHY_DEBUG: #{msg}"
      end
    end

    # Create an instance of the commandline application of launchy
    def command_line
      Launchy::CommandLine.new
    end
  end
end

require 'launchy/application'
require 'launchy/browser'
require 'launchy/command_line'
require 'launchy/version'

require 'spoon' if Launchy::Application.my_os_family != :windows and
                   Launchy::Application.is_jruby?
