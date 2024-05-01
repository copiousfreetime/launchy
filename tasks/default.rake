# frozen_string_literal: true

# vim: syntax=ruby
require "rake/clean"
require "digest"
#------------------------------------------------------------------------------
# Minitest - standard TestTask
#------------------------------------------------------------------------------
begin
  require "minitest/test_task"
  Minitest::TestTask.create(:test) do |t|
    t.libs << "spec"
    t.warning = true
    t.test_globs = "{test,spec}/**/{test_*,*_spec}.rb"
  end

  desc "Run the requirements for the tests"
  task "test:requirements"

  desc "and the requirements"
  task test: "test:requirements"
  task default: :test
rescue LoadError
  This.task_warning("test")
end

#------------------------------------------------------------------------------
# Coverage - integrated with minitest
#------------------------------------------------------------------------------
begin
  require "simplecov"
  desc "Run tests with code coverage"
  Minitest::TestTask.create(:coverage) do |t|
    t.test_prelude = 'require "simplecov"; SimpleCov.start;'
    t.libs << "spec"
    t.warning = true
    t.test_globs = "{test,spec}/**/{test_*,*_spec}.rb"
  end
  CLOBBER << "coverage" if File.directory?("coverage")
rescue LoadError
  This.task_warning("simplecov")
end

#------------------------------------------------------------------------------
# RDoc - standard rdoc rake task, although we must make sure to use a more
#        recent version of rdoc since it is the one that has 'tomdoc' markup
#------------------------------------------------------------------------------
begin
  gem "rdoc" # otherwise we get the wrong task from stdlib
  require "rdoc/task"
  RDoc::Task.new do |t|
    t.markup   = "tomdoc"
    t.rdoc_dir = "doc"
    t.main     = "README.md"
    t.title    = "#{This.name} #{This.version}"
    t.rdoc_files.include(FileList["*.{rdoc,md,txt}"], FileList["ext/**/*.c"],
                         FileList["lib/**/*.rb"])
  end
rescue StandardError, LoadError
  This.task_warning("rdoc")
end

#------------------------------------------------------------------------------
# Reek - static code analysis
#------------------------------------------------------------------------------
begin
  require "reek/rake/task"
  Reek::Rake::Task.new
rescue LoadError
  This.task_warning("reek")
end

#------------------------------------------------------------------------------
# Rubocop - static code analysis
#------------------------------------------------------------------------------
begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  This.task_warning("rubocop")
end

def git_files
  IO.popen(%w[git ls-files -z], chdir: This.project_root, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true)
  end
end

#------------------------------------------------------------------------------
# Manifest - We want an explicit list of thos files that are to be packaged in
#            the gem. Most of this is from Hoe.
#------------------------------------------------------------------------------
namespace "manifest" do
  desc "Check the manifest"
  task check: :clean do
    files = FileList["**/*", ".*"].to_a.sort
    files = files.select { |f| (f =~ This.include_in_manifest) && File.file?(f) }

    tmp = "Manifest.tmp"
    File.open(tmp, "w") do |f|
      f.puts files.join("\n")
    end

    begin
      sh "diff -du Manifest.txt #{tmp}"
    ensure
      rm tmp
    end
    puts "Manifest looks good"
  end

  desc "Generate the manifest"
  task generate: :clean do
    files = git_files.grep(This.include_in_manifest)
    files.sort!
    File.open("Manifest.txt", "w") do |f|
      f.puts files.join("\n")
    end
  end
end

#------------------------------------------------------------------------------
# Fixme - look for fixmes and report them
#------------------------------------------------------------------------------
def fixme_project_root
  This.project_path("../fixme")
end

def fixme_project_path(subtree)
  fixme_project_root.join(subtree)
end

def local_fixme_files
  local_files = Dir.glob("tasks/**/*")
  local_files.concat(Dir.glob(".semaphore/*"))
  local_files.concat(Dir.glob(".rubocop.yml"))
  local_files.concat(Dir.glob("bin/*"))
end

def upstream_fixme_files
  fixme_project_root.glob("{tasks/**/*,.semaphore/*,.rubocop.yml,bin/*}")
end

def outdated_fixme_files
  local_fixme_files.select do |local|
    upstream = fixme_project_path(local)
    if upstream.exist?
      if File.exist?(local)
        (Digest::SHA256.file(local) != Digest::SHA256.file(upstream))
      else
        true
      end
    end
  end
end

def fixme_up_to_date?
  outdated_fixme_files.empty?
end

namespace :fixme do
  task default: "manifest:check" do
    This.manifest.each do |file|
      next if file == __FILE__
      next unless /(txt|rb|md|rdoc|css|html|xml|css)\Z/.match?(file)

      puts "FIXME: Rename #{file}" if /fixme/i.match?(file)
      File.readlines(file).each_with_index do |line, idx|
        prefix = "FIXME: #{file}:#{idx + 1}".ljust(42)
        puts "#{prefix} => #{line.strip}" if /fixme/i.match?(line)
      end
    end
  end

  desc "See the local fixme files"
  task :local_files do
    local_fixme_files.each do |f|
      puts f
    end
  end

  desc "See the upstream fixme files"
  task :upstream_files do
    upstream_fixme_files.each do |f|
      puts f
    end
  end

  desc "See if the fixme tools are outdated"
  task :outdated do
    if fixme_up_to_date?
      puts "Fixme files are up to date."
    else
      outdated_fixme_files.each do |f|
        puts "#{f} is outdated"
      end
    end
  end

  desc "Show the diff between the local and upstream fixme files"
  task :diff do
    outdated_fixme_files.each do |f|
      upstream = fixme_project_path(f)
      puts "===> Start Diff for #{f}"
      output = `diff -du #{upstream} #{f}`
      puts output unless output.empty?
      puts "===> End Diff for #{f}"
      puts
    end
  end

  desc "Update outdated fixme files"
  task :update do
    if fixme_up_to_date?
      puts "Fixme files are already up to date."
    else
      puts "Updating fixme files:"
      outdated_fixme_files.each do |local|
        upstream = fixme_project_path(local)
        puts "  * #{local}"
        FileUtils.cp(upstream, local)
      end
      puts "Use your git commands as appropriate."
    end
  end
end
desc "Look for fixmes and report them"
task fixme: "fixme:default"

#------------------------------------------------------------------------------
# Gem Specification
#------------------------------------------------------------------------------
# Really this is only here to support those who use bundler
desc "Build the #{This.name}.gemspec file"
task :gemspec do
  File.open(This.gemspec_file, "wb+") do |f|
    f.puts "# DO NOT EDIT - This file is automatically generated"
    f.puts "# Make changes to Manifest.txt and/or Rakefile and regenerate"
    f.write This.platform_gemspec.to_ruby
  end
end

# .rbc files from ruby 2.0
CLOBBER << "**/*.rbc"

# The standard gem packaging task, everyone has it.
require "rubygems/package_task"
Gem::PackageTask.new(This.platform_gemspec) do
  # nothing
end

#------------------------------------------------------------------------------
# Release - the steps we go through to do a final release, this is pulled from
#           a compbination of mojombo's rakegem, hoe and hoe-git
#
# 1) make sure we are on the main branch
# 2) make sure there are no uncommitted items
# 3) check the manifest and make sure all looks good
# 4) build the gem
# 5) do an empty commit to have the commit message of the version
# 6) tag that commit as the version
# 7) push main
# 8) push the tag
# 7) pus the gem
#------------------------------------------------------------------------------
desc "Check to make sure we are ready to release"
task :release_check do
  abort "You must be on the main branch to release!" unless /^\* main/.match?(`git branch`)
  abort "Nope, sorry, you have unfinished business" unless /^nothing to commit/m.match?(`git status`)
end

desc "Create tag v#{This.version}, build and push #{This.platform_gemspec.full_name} to rubygems.org"
task release: [:release_check, "manifest:check", :gem] do
  sh "git commit --allow-empty -a -m 'Release #{This.version}'"
  sh "git tag -a -m 'v#{This.version}' v#{This.version}"
  sh "git push origin main"
  sh "git push origin v#{This.version}"
  sh "gem push pkg/#{This.platform_gemspec.full_name}.gem"
end
