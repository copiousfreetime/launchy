require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'

$: << File.join(File.dirname(__FILE__),"lib")
require 'launchy'

# load all the extra tasks for the project
TASK_DIR = File.join(File.dirname(__FILE__),"tasks")
FileList[File.join(TASK_DIR,"*.rb")].each do |tasklib|
    require "tasks/#{File.basename(tasklib)}"
end

task :default => "test:default"

#-----------------------------------------------------------------------
# Documentation
#-----------------------------------------------------------------------
namespace :doc do

    # generating documentation locally
    Rake::RDocTask.new do |rdoc|
        rdoc.rdoc_dir   = Launchy::SPEC.local_rdoc_dir
        rdoc.options    = Launchy::SPEC.rdoc_options 
        rdoc.rdoc_files = Launchy::SPEC.rdoc_files
    end

    desc "View the RDoc documentation locally"
    task :view => :rdoc do
        show_files Launchy::SPEC.local_rdoc_dir
    end

end

#-----------------------------------------------------------------------
# Packaging and Distribution
#-----------------------------------------------------------------------
namespace :dist do

    Rake::GemPackageTask.new(Launchy::SPEC) do |pkg|
        pkg.need_tar = Launchy::SPEC.need_tar
        pkg.need_zip = Launchy::SPEC.need_zip
    end

    desc "Install as a gem"
    task :install => [:clobber, :package] do
        sh "sudo gem install pkg/#{Launchy::SPEC.full_name}.gem"
    end

    # uninstall the gem and all executables
    desc "Uninstall gem"
    task :uninstall do 
        sh "sudo gem uninstall #{Launchy::SPEC.name} -x"
    end

    desc "dump gemspec"
    task :gemspec do
        puts Launchy::SPEC.to_ruby
    end

    desc "reinstall gem"
    task :reinstall => [:install, :uninstall]

end
