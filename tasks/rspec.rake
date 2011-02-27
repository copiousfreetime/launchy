
require 'tasks/config'

#--------------------------------------------------------------------------------
# configuration for running rspec.  This shows up as the test:default task
#--------------------------------------------------------------------------------
if spec_config = Configuration.for_if_exist?("test") then
  if spec_config.mode == "spec" then
    namespace :test do

      task :default => :spec

      require 'rspec/core/rake_task'
      rs = RSpec::Core::RakeTask.new do |r|
        r.ruby_opts   = spec_config.ruby_opts
        r.rspec_opts  = spec_config.options

        if rcov_config = Configuration.for_if_exist?('rcov') then
          r.rcov      = false
          r.rcov_opts = rcov_config.rcov_opts
        end
      end
    end
  end
end
