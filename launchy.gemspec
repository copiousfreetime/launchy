# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'launchy/version'

Gem::Specification.new do |s|
  s.name        = 'launchy'
  s.version     = Launchy::VERSION
  s.platform    = Gem::Platform::CURRENT
  s.authors     = ['Jeremy Hinegardner']
  s.email       = ['jeremy@copiousfreetime.org']
  s.homepage    = 'http://www.copiousfreetime.org/projects/launchy'
  s.summary     = 'Launchy is helper class for launching cross-platform applications in a fire and forget manner.'
  s.description = <<_
Launchy is helper class for launching cross-platform applications in a
fire and forget manner.

There are application concepts (browser, email client, etc) that are
common across all platforms, and they may be launched differently on
each platform. Launchy is here to make a common approach to launching
external application from within ruby programs.
_

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'launchy'

  if RUBY_PLATFORM == 'java' then
    s.add_dependency 'spoon', '~> 0.0.1'
  end

  s.add_development_dependency 'bundler',  '~> 1.0.13'
  s.add_development_dependency 'rake',     '~> 0.8.7'
  s.add_development_dependency 'minitest', '~> 2.1.0'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README HISTORY]
  s.require_path = 'lib'

  s.rdoc_options = ["--title", "Launchy", "--main", "README", "--line-numbers"]
  s.extra_rdoc_files = %w[LICENSE README HISTORY]

  s.test_files = Dir.glob('spec/**')
end
