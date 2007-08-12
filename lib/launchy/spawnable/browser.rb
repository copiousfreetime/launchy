require 'launchy/spawnable/application'
require 'uri'

module Launchy
    module Spawnable
        class Browser < Application
            
            DESKTOP_ENVIRONMENT_BROWSER_LAUNCHERS = {
                :kde     => %w[ kfmclient ],
                :gnome   => %w[ gnome-open ],
                :xfce    => %w[ exo-open ],
                :generic => %w[ htmlview ]
            }
            
            FALLBACK_BROWSERS = %w[ firefox seamonkey opera mozilla netscape galeon links lynx ]
            
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
                
                # Find a list of potential browser applications to run on *nix machines.  
                # The order is:
                #     1) What is in ENV['LAUNCHY_BROWSER'] or ENV['BROWSER']
                #     2) xdg-open
                #     3) desktop environment launcher program
                #     4) a list of fallback browsers
                def nix_app_list
                    browser_cmds = []
                    browser_cmds << ENV['LAUNCHY_BROWSER']
                    browser_cmds << ENV['BROWSER']
                    browser_cmds << "xdg-open"
                    browser_cmds << DESKTOP_ENVIRONMENT_BROWSER_LAUNCHERS[nix_desktop_environment]
                    browser_cmds << FALLBACK_BROWSERS
                    browser_cmds.flatten!
                    browser_cmds.delete_if { |b| b.nil? || (b.strip.size == 0) }
                    Launchy.log "*Nix Browser List: #{browser_cmds.join(', ')}"
                    browser_cmds
                end
                                    
            end
            
            APP_LIST = { 
                :windows => %w[ start ],
                :darwin  => %w[ open ],
                :nix     => nix_app_list,
                :unknown => [],
                }
            
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