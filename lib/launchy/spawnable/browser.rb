require 'launchy/spawnable/application'
require 'uri'

module Launchy
    module Spawnable
        class Browser < Application
            APP_LIST = { 
                :windows => %w[ firefox iexplore ],
                :darwin  => %w[ open ],
                :nix     => %w[ firefox ],
                :unknown => [],
                }
            class << self
                def run(*args)
                    Browser.new.visit(args[0]) 
                end
                
                # return true if this class can handle the given parameter(s)
                def handle?(*args)
                    begin 
                        uri = URI.parse(args[0])
                        return [URI::HTTP, URI::HTTPS, URI::FTP].include?(uri.class)
                    rescue Exception 
                        return false
                    end
                end
            end
            
            def initialize
                raise "Unable to find browser to launch for os family '#{my_os_family}'." unless browser
            end
            
            # returns the list of command line application names for the current os
            def app_list
                APP_LIST[my_os_family]
            end
            
            # return the full command line path to the browser or nil
            def browser
                @browser ||= app_list.collect { |bin| find_executable(bin) }.reject { |x| x.nil? }.first
            end
            
            # launch the browser at the appointed url
            def visit(url)
                run(browser,url)
            end
            
        end
    end
end