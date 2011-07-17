require 'shellwords'

module Launchy::Detect
  class Runner
    class NotFoundError < Launchy::Error; end

    extend ::Launchy::DescendantTracker

    # Detect the current command runner
    #
    # If a runner cannot be detected then raise Runner::NotFoundError
    def self.detect
      host_os_family = Launchy::Detect::HostOsFamily.detect
      ruby_engine    = Launchy::Detect::RubyEngine.detect

      return Windows.new if host_os_family.windows?
      if ruby_engine.jruby? then
        require 'spoon'
        return Jruby.new
      end
      return Forkable.new 
    end

    #
    # cut it down to just the shell commands that will be passed to exec or
    # posix_spawn.
    def shell_commands( cmd, args )
      cmds = [ cmd.shellsplit, args.collect{ |a| a.to_s } ].flatten.find_all { |a| not a.nil? and a.size > 0 }
      Launchy.log "ARGV => #{cmds.inspect}"
      return cmds
    end

    def run( cmd, *args )
      if Launchy.dry_run? then
        puts dry_run( cmd, *args )
      else
        wet_run( cmd, *args )
      end
    end


    #---------------------------------------
    # The list of known runners
    #---------------------------------------

    class Windows < Runner
      def dry_run( cmd, *args )
        "cmd /c #{cmd} #{args.join(' ')}"
      end

      def wet_run( cmd, *args )
        system 'cmd', '/c', cmd, *args
      end
    end

    class Jruby < Runner

      def dry_run( cmd, *args )
        shell_commands(cmd, args).join(" ")
      end

      def wet_run( cmd, *args )
        Spoon.spawnp( *shell_commands( cmd, args ))
      end
    end

    class Forkable < Runner
      def dry_run( cmd, *args )
        shell_commands(cmd, args).join(" ")
      end

      def wet_run( cmd, *args )
        child_pid = fork do
          exec( *shell_commands( cmd, args ))
          exit!
        end
        Process.detach( child_pid )
      end
    end
  end
end
