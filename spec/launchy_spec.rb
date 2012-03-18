require 'spec_helper'

describe Launchy do

  before do
    Launchy.reset_global_options
    @stderr  = $stderr
    $stderr = StringIO.new
  end

  after do
    Launchy.reset_global_options
    $stderr = @stderr
  end

  it "logs to stderr when LAUNCHY_DEBUG environment variable is set" do
    ENV["LAUNCHY_DEBUG"] = 'true'
    old_stderr = $stderr
    $stderr = StringIO.new
    Launchy.log "This is a test log message"
    $stderr.string.strip.must_equal "LAUNCHY_DEBUG: This is a test log message"
    $stderr = old_stderr
    ENV["LAUNCHY_DEBUG"] = nil
  end

  it "sets the global option :dry_run to value of LAUNCHY_DRY_RUN environment variable" do
    ENV['LAUNCHY_DRY_RUN'] = 'true'
    Launchy.extract_global_options({})
    Launchy.dry_run?.must_equal 'true'
    ENV['LAUNCHY_DRY_RUN'] = nil
  end

  it "has the global option :debug" do
    Launchy.extract_global_options( { :debug => 'true' } )
    Launchy.debug?.must_equal true
  end

  it "has the global option :application" do
    Launchy.extract_global_options(  { :application => "wibble" } )
    Launchy.application.must_equal 'wibble'
  end

  it "has the global option :host_os" do
    Launchy.extract_global_options(  { :host_os => "my-special-os-v2" } )
    Launchy.host_os.must_equal 'my-special-os-v2'
  end

  it "has the global option :ruby_engine" do
    Launchy.extract_global_options(  { :ruby_engine => "myruby" } )
    Launchy.ruby_engine.must_equal 'myruby'
  end

  it "prints an error on stderr when no scheme is found for the given uri" do
    Launchy.open( "blah://something/invalid" )
    $stderr.string.must_match( /Failure in opening/ )
  end

end
