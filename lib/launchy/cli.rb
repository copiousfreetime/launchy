require 'optparse'

module Launchy
  class Cli

    attr_reader :options
    def initialize
      @options = {}
    end
  
    def parser
      @parser ||= OptionParser.new do |op|
        op.banner = "Usage: launchy [options] thing-to-launch"

        op.separator ""
        op.separator "Launch Options:"

        op.on( "-a", "--application APPLICATION", 
               "Explicitly specify the application class to use in the launch") do |app|
          options[:application] = app
        end

        op.on( "-d", "--debug", 
               "Force debug. Output lots of information.") do |d|
          options[:debug] = 'true'
        end

        op.on( "-e", "--engine RUBY_ENGINE",
               "Force launchy to behave as if it was on a particular ruby engine.") do |e|
          options[:ruby_engine] = e
        end

        op.on( "-o", "--host-os HOST_OS", 
               "Force launchy to behave as if it was on a particular host os.") do |os|
          options[:host_os] = os
        end


        op.separator ""
        op.separator "Standard Options:"

        op.on( "-h", "--help", "Print this message.") do |h|
          puts op.to_s
          exit 0
        end

        op.on( "-v", "--version", "Output the version of Launchy") do |v|
          puts "Launchy version #{Launchy::VERSION}"
          exit 0
        end

      end
    end

    def run( argv = ARGV, env = ENV )
      begin
        parser.parse!( argv )
        Launchy.open( *argv )
      rescue ::OptionParser::ParseError => pe
        $stderr.puts "#{parser.program_name}: #{pe}"
        $stderr.puts "Try `#{parser.program_name} --help for more information."
        exit 1
      end
    end
  end
end
