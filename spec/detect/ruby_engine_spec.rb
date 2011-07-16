require 'spec_helper'
require 'yaml'

describe Launchy::Detect::RubyEngine do

  before do
    Launchy.reset_global_options
  end

  after do
    Launchy.reset_global_options
  end

  %w[ ruby jruby rbx macruby ].each do |ruby|
    it "detects the #{ruby} RUBY_ENGINE" do
      Launchy::Detect::RubyEngine.detect( ruby ).wont_equal Launchy::Detect::RubyEngine::Unknown
    end
  end

  it "uses the global ruby_engine overrides" do
    ENV['LAUNCHY_RUBY_ENGINE'] = "rbx"
    Launchy::Detect::RubyEngine.detect.must_equal Launchy::Detect::RubyEngine::Rbx
    ENV.delete('LAUNCHY_RUBY_ENGINE')
  end

  it "does not find a ruby engine of 'foo'" do
    Launchy::Detect::RubyEngine.detect( 'foo' ).must_equal Launchy::Detect::RubyEngine::Unknown
  end

end
