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
                spec.homepage           = "http://copiousfreetime.rubyforge.org/launchy/"

                spec.summary            = "A helper to launch apps from within ruby programs."
                spec.description        = <<-DESC
                Launchy is helper class for launching cross-platform applications in a
                fire and forget manner.  

                There are application concepts (browser, email client, etc) that are common
                across all platforms, and they may be launched differently on each
                platform.  Launchy is here to make a common approach to launching
                external application from within ruby programs.
                
                DESC

                spec.extra_rdoc_files   = FileList["CHANGES", "LICENSE", "README"]
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
end


