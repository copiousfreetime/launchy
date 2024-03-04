require 'childprocess'
module Launchy
  class Runner
    def run( cmd, *args )
      raise Launchy::CommandNotFoundError, "No command found to run with args '#{args.join(' ')}'. If this is unexpected, #{Launchy.bug_report_message}" unless cmd
      if Launchy.dry_run? then
        $stdout.puts dry_run( cmd, *args )
      else
        wet_run( cmd, *args )
      end
    end

    def wet_run( cmd, *args )
      argv = [ cmd, *args ].flatten
      Launchy.log "ChildProcess: argv => #{argv.inspect}"
      process = ChildProcess.build( *argv )

      process.io.inherit!
      process.leader = true
      process.detach = true
      process.start
    end

    def dry_run( cmd, *args )
      shell_commands(cmd, args).join(" ")
    end

    # cut it down to just the shell commands that will be passed to exec or
    # posix_spawn. The cmd argument is split according to shell rules and the
    # args are not escaped because the whole set is passed to system as *args
    # and in that case system shell escaping rules are not done.
    #
    def shell_commands( cmd, args )
      cmdline = [ cmd.to_s.shellsplit ]
      cmdline << args.flatten.collect{ |a| a.to_s }
      return commandline_normalize( cmdline )
    end

    def commandline_normalize( cmdline )
      c = cmdline.flatten!
      c = c.find_all { |a| (not a.nil?) and ( a.size > 0 ) }
      Launchy.log "commandline_normalized => #{c.join(' ')}"
      return c
    end
  end
end
