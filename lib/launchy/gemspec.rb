require 'rubygems'
require 'launchy/specification'
require 'launchy/version'
require 'rake'

# The Gem Specification plus some extras for launchy.
module Launchy
    SPEC = Launchy::Specification.new do |spec|
                spec.name               = "launchy"
                spec.version            = Launchy::VERSION
                spec.rubyforge_project  = "copiousfreetime"
                spec.author             = "Jeremy Hinegardner"
                spec.email              = "jeremy@hinegardner.org"
                spec.homepage           = "http://launchy.rubyforge.org/"

                spec.summary            = "A helper to launch apps from within ruby programs."
                spec.description        = <<-DESC
                Launchy is helper class for launching +cross-platform+
                applications.

                There are application concepts (browser, email client,
                etc) that are common across all platforms, and they may
                be launched in different manners.  Launchy is here to
                assist in launching the appropriate application on the
                appropriate platform from within your ruby projects.
                DESC

                spec.extra_rdoc_files   = FileList["[A-Z]*"]
                spec.has_rdoc           = true
                spec.rdoc_main          = "README"
                spec.rdoc_options       = [ "--line-numbers" , "--inline-source" ]

                spec.test_files         = FileList["spec/**/*.rb", "test/**/*.rb"]
                spec.files              = spec.test_files + spec.extra_rdoc_files + 
                                          FileList["lib/**/*.rb", "resources/**/*"]
                
                spec.executable         = spec.name

                spec.platform           = Gem::Platform::RUBY
                spec.required_ruby_version  = ">= 1.8.5"

                spec.local_rdoc_dir     = "doc/rdoc"
                spec.remote_rdoc_dir    = ""
                spec.local_coverage_dir = "doc/coverage"
                spec.remote_coverage_dir= "coverage"

                spec.remote_user        = "jjh"
                spec.remote_site_dir    = "#{spec.name}/"

           end

    SPEC_WIN32 = SPEC.dup
    SPEC_WIN32.add_dependency("win32-process")
    SPEC_WIN32.platform = Gem::Platform::WIN32
end


