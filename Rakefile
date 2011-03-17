#--
# Copyright (c) 2007 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

begin
  require 'bones'
rescue LoadError
  abort '### Pleas install the "bones" gem ###'
end

task :default => 'spec:run'
task 'gem:release' => 'spec:run'

$:.unshift( "lib" )
require 'launchy/version'

Bones {
  name      "launchy"
  author    "Jeremy Hinegardner"
  email     "jeremy@copiousfreetime.org"
  url       'http://www.copiousfreetime.org/projects/launchy'
  version   Launchy::VERSION

  ruby_opts     %w[ -W0 -rubygems ]
  readme_file   'README'
  ignore_file   '.gitignore'
  history_file  'HISTORY'

  rdoc.include << "README" << "HISTORY" << "LICENSE"
  spec.opts << "--color" << "--format documentation"

  summary 'Launchy is helper class for launching cross-platform applications in a fire and forget manner.'
  description <<_
Launchy is helper class for launching cross-platform applications in a
fire and forget manner.

There are application concepts (browser, email client, etc) that are
common across all platforms, and they may be launched differently on
each platform.  Launchy is here to make a common approach to launching
external application from within ruby programs.
_

  depend_on "spoon" , "~> 0.0.1" if RUBY_PLATFORM == "java"
  depend_on "rake"  , "~> 0.8.7", :development => true
  depend_on "rspec" , "~> 2.5.0", :development => true
  depend_on 'bones' , "~> 3.6.5", :development => true
}
