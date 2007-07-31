require 'spec/rake/spectask'

#-----------------------------------------------------------------------
# Testing - this is either test or spec, include the appropriate one
#-----------------------------------------------------------------------
namespace :test do

    task :default => :spec

    Spec::Rake::SpecTask.new do |r| 
        r.rcov      = true
        r.rcov_dir  = Launchy::SPEC.local_coverage_dir
        r.libs      = Launchy::SPEC.require_paths
        r.spec_opts = %w(--format specdoc)
    end

    task :coverage => [:spec] do
        show_files Launchy::SPEC.local_coverage_dir
    end 
end
