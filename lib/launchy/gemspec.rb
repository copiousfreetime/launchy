require 'rubygems'
require 'launchy/specification'
require 'launchy/version'
require 'rake'

# The Gem Specification plus some extras for launchy.
module Launchy
    SPEC = Launchy::Specification.new do |spec|
                spec.name               = "launchy"
                spec.version            = Launchy::VERSION
                spec.rubyforge_project  = "launchy"
                spec.author             = "Jeremy Hinegardner"
                spec.email              = "jeremy@hinegardner.org"
                spec.homepage           = "http://launchy.rubyforge.org/"

                spec.summary            = "A Summary of launchy."
                spec.description        = <<-DESC
                A longer more detailed description of launchy.
                DESC

                spec.extra_rdoc_files   = FileList["[A-Z]*"]
                spec.has_rdoc           = true
                spec.rdoc_main          = "README"
                spec.rdoc_options       = [ "--line-numbers" , "--inline-source" ]

                spec.test_files         = FileList["spec/**/*.rb", "test/**/*.rb"]
                spec.files              = spec.test_files + spec.extra_rdoc_files + 
                                          FileList["lib/**/*.rb", "resources/**/*"]
                
                spec.executable         = spec.name

                if /(mswin)|(windows)/.match(RUBY_PLATFORM) then
                    spec.add_dependency("win32-process")
                    spec.platform           = Gem::Platform::WIN32
                else
                    spec.platform           = Gem::Platform::RUBY
                end
                spec.required_ruby_version  = ">= 1.8.5"

                spec.local_rdoc_dir     = "doc/rdoc"
                spec.remote_rdoc_dir    = ""
                spec.local_coverage_dir = "doc/coverage"
                spec.remote_coverage_dir= "coverage"

                spec.remote_site_dir    = "#{spec.name}/"

           end
end


