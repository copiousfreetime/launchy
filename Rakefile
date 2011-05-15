require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace(:test) do
  desc 'Run all tests on multiple ruby versions (requires rvm)'
  task(:portability) do
    %w[1.8.7 1.9.2 jruby-1.6.1].each do |version|
      system <<-BASH
        bash -c 'source ~/.rvm/scripts/rvm;
                 rvm #{version};
                 echo "--------- version #{version} ----------\n";
                 bundle install;
                 rake test'
      BASH
    end
  end
end
