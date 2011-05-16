
module Launchy

  class << self
    #
    # Convenience method to launch an item
    #
    def open(uri, options = {} )
      begin
        uri = URI.parse( uri )
        if app = Launchy::Application.for_scheme( uri ) then
          app.new.open( uri, options )
        else
          msg = "Unable to launch #{uri} with options #{options.inspect}"
          Launchy.log "#{self.name} : #{msg}"
          $stderr.puts msg
        end
      rescue Exception => e
        msg = "Failure in opening #{params.join(' ')} : #{e}"
        Launchy.log "#{self.name} : #{msg}"
        $stderr.puts msg
      end
    end

    def debug?
      ENV['LAUNCHY_DEBUG'] == 'true'
    end

    # Setting the LAUNCHY_DEBUG environment variable to 'true' will spew
    # debug information to $stderr
    def log(msg)
      $stderr.puts "LAUNCHY_DEBUG: #{msg}" if debug?
    end
  end
end

require 'launchy/version'
require 'launchy/error'
require 'launchy/application'
