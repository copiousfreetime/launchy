# vim: syntax=ruby

This.name     = "launchy"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"
This.version  = Util.version

#------------------------------------------------------------------------------
# If you want to Develop on this project just run 'rake develop' and you'll
# have all you need to get going. If you want to use bundler for development,
# then run 'rake develop:using_bundler'
#------------------------------------------------------------------------------
namespace :develop do

  # Install all the development and runtime dependencies of this gem using the
  # gemspec.
  task :default do
    require 'rubygems/dependency_installer'
    installer = Gem::DependencyInstaller.new

    puts "Installing gem depedencies needed for development"
    Util.platform_gemspec.dependencies.each do |dep|
      if dep.matching_specs.empty? then
        puts "Installing : #{dep}"
        installer.install dep
      else
        puts "Skipping   : #{dep} -> already installed #{dep.matching_specs.first.full_name}"
      end
    end
    puts "\n\nNow run 'rake test'"
  end

  # Create a Gemfile that just references the gemspec
  file 'Gemfile' => :gemspec do
    File.open( "Gemfile", "w+" ) do |f|
      f.puts 'source :rubygems'
      f.puts 'gemspec'
    end
  end

  desc "Create a bundler Gemfile"
  task :using_bundler => 'Gemfile' do
    puts "Now you can 'bundle'"
  end

  # Gemfiles are build artifacts
  CLOBBER << FileList['Gemfile*']
end
desc "Boostrap development"
task :develop => "develop:default"

#------------------------------------------------------------------------------
# Minitest - standard TestTask
#------------------------------------------------------------------------------
begin
  require 'rake/testtask'
  Rake::TestTask.new( :test ) do |t|
    t.ruby_opts    = %w[ -w -rubygems ]
    t.libs         = %w[ lib spec ]
    t.pattern      = "spec/**/*_spec.rb"
  end
  task :default => :test
rescue LoadError
  Util.task_warning( 'test' )
end

#------------------------------------------------------------------------------
# RDoc - standard rdoc rake task, although we must make sure to use a more
#        recent version of rdoc since it is the one that has 'tomdoc' markup
#------------------------------------------------------------------------------
begin
  gem 'rdoc' # otherwise we get the wrong task from stdlib
  require 'rdoc/task'
  RDoc::Task.new do |t|
    t.markup   = 'tomdoc'
    t.rdoc_dir = 'doc'
    t.main     = 'README.rdoc'
    t.title    = "#{This.name} #{This.version}"
    t.rdoc_files.include( '*.rdoc', 'lib/**/*.rb' )
  end
rescue LoadError => le
  Util.task_warning( 'rdoc' )
end

#------------------------------------------------------------------------------
# Coverage - optional code coverage, rcov for 1.8 and simplecov for 1.9, so
#            for the moment only rcov is listed.
#------------------------------------------------------------------------------
begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs      << 'spec'
    t.pattern   = 'spec/**/*_spec.rb'
    t.verbose   = true
    t.rcov_opts << "-x ^/"           # remove all the global files
    t.rcov_opts << "--sort coverage" # so we see the worst files at the top
  end
rescue LoadError
  $stderr.puts "rcov task is not defined, please 'gem install rcov'"
end

#------------------------------------------------------------------------------
# Manifest - We want an explicit list of thos files that are to be packaged in
#            the gem. Most of this is from Hoe.
#------------------------------------------------------------------------------
namespace 'manifest' do
  desc "Check the manifest"
  task :check => :clean do
    files = FileList["**/*", ".*"].exclude( This.exclude_from_manifest ).to_a.sort
    files = files.select{ |f| File.file?( f ) }

    tmp = "Manifest.tmp"
    File.open( tmp, 'w' ) do |f|
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
  task :generate => :clean do
    files = %x[ git ls-files ].split("\n").sort
    files.reject! { |f| f =~ This.exclude_from_manifest }
    File.open( "Manifest.txt", "w" ) do |f|
      f.puts files.join("\n")
    end
  end
end

#------------------------------------------------------------------------------
# Gem Specification
#------------------------------------------------------------------------------
This.gemspec = Hash.new
This.gemspec['ruby'] = Gem::Specification.new do |spec|
  spec.name        = This.name
  spec.version     = This.version
  spec.author      = This.author
  spec.email       = This.email
  spec.homepage    = This.homepage

  spec.summary     = This.summary
  spec.description = This.description

  spec.files       = This.manifest
  spec.executables = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files  = spec.files.grep(/^spec/)

  spec.extra_rdoc_files += spec.files.grep(/(txt|rdoc)$/)
  spec.rdoc_options = [ "--main"  , 'README.rdoc', ]

  # The Runtime Dependencies
  spec.add_runtime_dependency( 'addressable', '~> 2.3' )

  # The Development Dependencies
  spec.add_development_dependency( 'rake'     , '~> 0.9.2.2')
  spec.add_development_dependency( 'minitest' , '~> 3.3.0' )
  spec.add_development_dependency( 'rdoc'     , '~> 3.12'   )
  spec.add_development_dependency( 'spoon'    , '~> 0.0.1'  )
  spec.add_development_dependency( 'ffi'      , '~> 1.1.1'  )

end

#----------------------------------------------
# JRuby spec has a few more runtime dependencies
#----------------------------------------------
jruby_gemspec = This.gemspec['ruby'].dup
jruby_gemspec.add_runtime_dependency( 'spoon', '~> 0.0.1' )
jruby_gemspec.add_runtime_dependency( 'ffi'  , '~> 1.1.1' )
jruby_gemspec.platform = 'java'
This.gemspec['java']  = jruby_gemspec


# The name of the gemspec file on disk
This.gemspec_file = "#{This.name}.gemspec"

# Really this is only here to support those who use bundler
desc "Build the #{This.name}.gemspec file"
task :gemspec do
  File.open( This.gemspec_file, "wb+" ) do |f|
    f.write Util.platform_gemspec.to_ruby
  end
end

# the gemspec is also a dev artifact and should not be kept around.
CLOBBER << This.gemspec_file

# The standard gem packaging task, everyone has it.
require 'rubygems/package_task'
Gem::PackageTask.new( Util.platform_gemspec ) do
  # nothing
end

#------------------------------------------------------------------------------
# Release - the steps we go through to do a final release, this is pulled from
#           a compbination of mojombo's rakegem, hoe and hoe-git
#
# 1) make sure we are on the master branch
# 2) make sure there are no uncommitted items
# 3) check the manifest and make sure all looks good
# 4) build the gem
# 5) do an empty commit to have the commit message of the version
# 6) tag that commit as the version
# 7) push master
# 8) push the tag
# 7) pus the gem
#------------------------------------------------------------------------------
task :release_check do
  unless `git branch` =~ /^\* master$/
    abort "You must be on the master branch to release!"
  end
  unless `git status` =~ /^nothing to commit/m
    abort "Nope, sorry, you have unfinished business"
  end
end

desc "Create tag v#{This.version}, build and push #{Util.platform_gemspec.full_name} to rubygems.org"
task :release => [ :release_check, 'manifest:check', :gem ] do
  sh "git commit --allow-empty -a -m 'Release #{This.version}'"
  sh "git tag -a -m 'v#{This.version}' v#{This.version}"
  sh "git push origin master"
  sh "git push origin v#{This.version}"
  sh "gem push pkg/#{Util.platform_gemspec.full_name}.gem"
end

#------------------------------------------------------------------------------
# Rakefile Support - This is all the guts and utility methods that are
#                    necessary to support the above tasks.
#
# Lots of Credit for this Rakefile goes to:
#
#   Ara T. Howard       - see the Rakefile in all of his projects -
#                          https://github.com/ahoward/
#   Tom Preston Werner  - his Rakegem project https://github.com/mojombo/rakegem
#   Seattle.rb          - Hoe - cuz it has relly good stuff in there
#------------------------------------------------------------------------------
BEGIN {

  require 'ostruct'
  require 'rake/clean'
  require 'rubygems' unless defined? Gem

  module Util
    def self.version
      [ "lib/#{ This.name }.rb", "lib/#{ This.name }/version.rb" ].each do |v|
        line = File.read( v )[/^\s*VERSION\s*=\s*.*/]
        if line then
          return line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
        end
      end
    end

    # Partition an rdoc file into sections and return the text of the section
    # as an array of paragraphs
    def self.section_of( file, section_name )
      re    = /^=+ (.*)$/
      parts = File.read( file ).split( re )[1..-1]
      parts.map! { |p| p.strip }

      sections = Hash.new
      Hash[*parts].each do |k,v|
        sections[k] = v.split("\n\n")
      end
      return sections[section_name]
    end

    def self.task_warning( task )
      warn "WARNING: '#{task}' tasks are not defined. Please run 'rake develop'"
    end

    def self.read_manifest
      abort "You need a Manifest.txt" unless File.readable?( "Manifest.txt" )
      File.readlines( "Manifest.txt" ).map { |l| l.strip }
    end

    def self.platform_gemspec
      This.gemspec[This.platform]
    end
  end

  # Hold all the metadata about this project
  This = OpenStruct.new
  This.platform = (RUBY_PLATFORM == "java") ? 'java' : Gem::Platform::RUBY

  desc = Util.section_of( 'README.rdoc', 'DESCRIPTION')
  This.summary     = desc.first
  This.description = desc.join(" ").tr("\n", ' ').gsub(/[{}]/,'').gsub(/\[[^\]]+\]/,'') # strip rdoc


  This.exclude_from_manifest = %r/tmp$|\.(git|DS_Store)|^(doc|coverage|pkg)|\.gemspec$|\.swp$|\.jar|\.rvmrc$|~$/
  This.manifest = Util.read_manifest

}
