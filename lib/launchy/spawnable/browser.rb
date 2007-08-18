require 'launchy/spawnable/application'
require 'uri'

module Launchy
    module Spawnable
        class Browser < Application
            
            DESKTOP_ENVIRONMENT_BROWSER_LAUNCHERS = {
                :kde     => "kfmclient",
                :gnome   => "gnome-open",
                :xfce    => "exo-open",
                :generic => "htmlview"
            }
            
            FALLBACK_BROWSERS = %w[ firefox seamonkey opera mozilla netscape galeon ]
            
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
                    if not @nix_app_list then
                        browser_cmds = ['xdg-open']
                        browser_cmds << DESKTOP_ENVIRONMENT_BROWSER_LAUNCHERS[nix_desktop_environment]
                        browser_cmds << FALLBACK_BROWSERS
                        browser_cmds.flatten!
                        browser_cmds.delete_if { |b| b.nil? || (b.strip.size == 0) }
                        Launchy.log "Initial *Nix Browser List: #{browser_cmds.join(', ')}"
                        @nix_app_list = browser_cmds.collect { |bin| find_executable(bin) }.find_all { |x| not x.nil? }
                        Launchy.log "Filtered *Nix Browser List: #{@nix_app_list.join(', ')}"
                    end
                    @nix_app_list
                end
                                    
            end
            
            def initialize
                raise "Unable to find browser to launch for os family '#{my_os_family}'." unless browser
            end                        
            
            # return the full command line path to the browser or nil
            def browser
                if not @browser then
                    if ENV['LAUNCHY_BROWSER'] and File.exists?(ENV['LAUNCHY_BROWSER']) then
                        Launchy.log "Using LAUNCHY_BROWSER environment variable : #{ENV['LAUNCHY_BROWSER']}"
                        @browser = ENV['LAUNCHY_BROWSER']
                    elsif ENV['BROWSER'] and File.exists?(ENV['BROWSER']) then
                        Launchy.log "Using BROWSER environment variable : #{ENV['BROWSER']}"
                        @browser = ENV['BROWSER']
                    elsif app_list.size > 0 then
                        @browser = app_list.first
                        Launchy.log "Using application list : #{@browser}"
                    else
                        $stderr.puts "Unable to launch. No Browser application found."
                    end
                end
                return @browser
            end
            
            # launch the browser at the appointed url
            def visit(url)
                run(browser,url)
            end
            
        end
    end
end
