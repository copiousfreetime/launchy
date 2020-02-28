# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "launchy"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_dependency( 'addressable', '~> 2.7')

  spec.add_development_dependency( 'rake'     , '~> 13.0')
  spec.add_development_dependency( 'minitest' , '~> 5.14' )
  spec.add_development_dependency( 'rdoc'     , '~> 6.2' )
  spec.add_development_dependency( 'simplecov', '~> 0.18' )

  spec.licenses = ['ISC']

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/copiousfreetime/launchy/issues",
    "changelog_uri"   => "https://github.com/copiousfreetime/launchy/blob/master/README.md",
    "homepage_uri"    => "https://github.com/copiousfreetime/launchy",
    "source_code_uri" => "https://github.com/copiousfreetime/launchy",
  }
end

load 'tasks/default.rake'
