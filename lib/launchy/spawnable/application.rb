require 'launchy/spawnable'
require 'rbconfig'
require 'systemu'

module Launchy
    module Spawnable
        class Application
            
            KNOWN_OS_FAMILIES = [ :windows, :darwin, :nix ]
            
            class << self
                def inherited(sub_class)
                    application_classes << sub_class
                end            
                def application_classes
                    @application_classes ||= []
                end                
                
                def find_application_class_for(*args)
                    application_classes.find { |klass| klass.handle?(*args) }
                end
            end
            
            # find an executable in the available paths
            # mkrf did such a good job on this I had to borrow it.
            def find_executable(bin,*paths)
                paths = ENV['PATH'].split(File::PATH_SEPARATOR) if paths.empty?
                paths.each do |path|
                    file = File.join(path,bin)
                    return file if File.executable?(file)
                end
                return nil
            end
            
            # return the current 'host_os' string from ruby's configuration
            def my_os
                ::Config::CONFIG['host_os']
            end
            
            # detect what the current os is and return :windows, :darwin, :nix or :java
            def my_os_family(test_os = my_os)
                case test_os
                when /mswin/i
                    family = :windows
                when /windows/i
                    family = :windows
                when /darwin/i
                    family = :darwin
                when /mac os/i
                    family = :darwin
                when /solaris/i
                    family = :nix
                when /bsd/i
                    family = :nix
                when /linux/i
                    family = :nix
                when /cygwin/i
                    family = :nix
                else
                    $stderr.puts "Unknown OS familiy for '#{test_os}'.  Please report this bug."
                    family = :unknown
                end
            end
            
            # run the command via systemu
            def run(cmd,*args)
                args.unshift(cmd)
                systemu args.join(' ')
            end
        end
    end
end