require 'rubygems'
require 'rubygems/specification'
require 'rake'

module Launchy 
    # Add some additional items to Gem::Specification
    # A Launchy::Specification adds additional pieces of information the
    # typical gem specification
    class Specification 

        RUBYFORGE_ROOT = "/var/www/gforge-projects/"
      
        # user that accesses remote site
        attr_accessor :remote_user

        # remote host, default 'rubyforge.org'
        attr_accessor :remote_host

        # name the rdoc main
        attr_accessor :rdoc_main

        # local directory in development holding the generated rdoc
        # default 'doc'
        attr_accessor :local_rdoc_dir

        # remote directory for storing rdoc, default 'doc'
        attr_accessor :remote_rdoc_dir

        # local directory for coverage report
        attr_accessor :local_coverage_dir
        
        # remote directory for storing coverage reports
        # This defaults to 'coverage'
        attr_accessor :remote_coverage_dir

        # local directory for generated website, default +site/public+
        attr_accessor :local_site_dir
       
        # remote directory relative to +remote_root+ for the website.
        # website.
        attr_accessor :remote_site_dir

        # is a .tgz to be created?, default 'true'
        attr_accessor :need_tar

        # is a .zip to be created, default 'true'
        attr_accessor :need_zip


        def initialize
            @remote_user = nil
            @remote_host = "rubyforge.org"

            @rdoc_main              = "README"
            @local_rdoc_dir         = "doc"
            @remote_rdoc_dir        = "doc"
            @local_coverage_dir     = "coverage"
            @remote_coverage_dir    = "coverage"
            @local_site_dir         = "site/public"
            @remote_site_dir        = "."
            
            @need_tar   = true
            @need_zip   = true

            @spec                   = Gem::Specification.new

            yield self if block_given?

            # update rdoc options to take care of the rdoc_main if it is
            # there, and add a default title if one is not given
            if not @spec.rdoc_options.include?("--main") then
                @spec.rdoc_options.concat(["--main", rdoc_main])
            end

            if not @spec.rdoc_options.include?("--title") then
                @spec.rdoc_options.concat(["--title","'#{name} -- #{summary}'"])
            end
        end

        # if this gets set then it overwrites what would be the
        # rubyforge default.  If rubyforge project is not set then use
        # name.  If rubyforge project and name are set, but they are
        # different then assume that name is a subproject of the
        # rubyforge project
        def remote_root 
            if rubyforge_project.nil? or 
                rubyforge_project == name then
                return RUBYFORGE_ROOT + "#{name}/"
            else
                return RUBYFORGE_ROOT + "#{rubyforge_project}/#{name}/"
            end
        end

        # rdoc files is the same as what would be generated during gem
        # installation. That is, everything in the require paths plus
        # the rdoc_extra_files
        #
        def rdoc_files 
            flist = extra_rdoc_files.dup
            @spec.require_paths.each do |rp|
                flist << FileList["#{rp}/**/*.rb"]
            end
            flist.flatten.uniq
        end

        # calculate the remote directories
        def remote_root_location
            "#{remote_user}@#{remote_host}:#{remote_root}"
        end
           
        def remote_rdoc_location
            remote_root_location + @remote_rdoc_dir
        end

        def remote_coverage_location
            remote_root_loation + @remote_coverage_dir
        end

        def remote_site_location
            remote_root_location + @remote_site_dir
        end

        # we delegate any other calls to spec
        def method_missing(method_id,*params,&block)
            @spec.send method_id, *params, &block
        end

        # deep copy for duplication
        def dup
            Marshal.load(Marshal.dump(self))
        end
    end
end
