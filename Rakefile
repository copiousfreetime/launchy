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

    GEM_SPEC = eval(Launchy::SPEC.to_ruby)

    gem_task = Rake::GemPackageTask.new(GEM_SPEC) do |pkg|
        pkg.need_tar = Launchy::SPEC.need_tar
        pkg.need_zip = Launchy::SPEC.need_zip
    end

    GEM_SPEC_WIN32 = eval(Launchy::SPEC_WIN32.to_ruby)

    desc "Build the Win32 gem"
    task :gem_win32 => [ "#{gem_task.package_dir}/#{GEM_SPEC_WIN32.file_name}" ]
    file "#{gem_task.package_dir}/#{GEM_SPEC_WIN32.file_name}" => [gem_task.package_dir] + GEM_SPEC_WIN32.files do 
        gem_file = Gem::Builder.new(GEM_SPEC_WIN32).build
        mv gem_file, "#{gem_task.package_dir}/#{gem_file}"
    end
    task :package => [:gem_win32]

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

    desc "dump win32 gemspec"
    task :gemspec_win32 do
        puts Launchy::SPEC_WIN32.to_ruby
    end

    desc "reinstall gem"
    task :reinstall => [:install, :uninstall]

end

#-----------------------------------------------------------------------
# update the top level clobber task to depend on all possible sub-level
# tasks that have a name like ':clobber'  in other namespaces
#-----------------------------------------------------------------------
Rake.application.tasks.each do |t| 
    if t.name =~ /:clobber/ then
        task :clobber => [t.name]
    end 
end

