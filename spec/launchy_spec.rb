require 'spec_helper'
require 'pathname'
require 'mock_application'

describe Launchy do

  before do
    Launchy.reset_global_options
    @stderr  = $stderr
    $stderr = StringIO.new
    @stdout = $stdout
    $stdout = StringIO.new
    @invalid_url = 'blah://example.com/invalid'
  end

  after do
    Launchy.reset_global_options
    $stderr = @stderr
    $stdout = @stdout
  end

  it "logs to stderr when LAUNCHY_DEBUG environment variable is set" do
    ENV["LAUNCHY_DEBUG"] = 'true'
    old_stderr = $stderr
    $stderr = StringIO.new
    Launchy.log "This is a test log message"
    _($stderr.string.strip).must_equal "LAUNCHY_DEBUG: This is a test log message"
    $stderr = old_stderr
    ENV["LAUNCHY_DEBUG"] = nil
  end

  it "sets the global option :dry_run to true if LAUNCHY_DRY_RUN environment variable is 'true'" do
    ENV['LAUNCHY_DRY_RUN'] = 'true'
    Launchy.extract_global_options({})
    _(Launchy.dry_run?).must_equal true
    ENV['LAUNCHY_DRY_RUN'] = nil
  end

  it "sets the global option :debug to true if LAUNCHY_DEBUG environment variable is 'true'" do
    ENV['LAUNCHY_DEBUG'] = 'true'
    Launchy.extract_global_options({})
    _(Launchy.debug?).must_equal true
    ENV['LAUNCHY_DEBUG'] = nil
  end

  it "has the global option :debug" do
    Launchy.extract_global_options( { :debug => 'true' } )
    _(Launchy.debug?).must_equal true
    Launchy.extract_global_options( { :debug => true } )
    _(Launchy.debug?).must_equal true
  end

  it "has the global option :dry_run" do
    Launchy.extract_global_options( { :dry_run => 'true' } )
    _(Launchy.dry_run?).must_equal true
    Launchy.extract_global_options( { :dry_run => true } )
    _(Launchy.dry_run?).must_equal true
  end

  it "has the global option :application" do
    Launchy.extract_global_options(  { :application => "wibble" } )
    _(Launchy.application).must_equal 'wibble'
  end

  it "has the global option :host_os" do
    Launchy.extract_global_options(  { :host_os => "my-special-os-v2" } )
    _(Launchy.host_os).must_equal 'my-special-os-v2'
  end

  it "raises an exception if no scheme is found for the given uri" do
    _(lambda { Launchy.open( @invalid_url ) }).must_raise Launchy::ApplicationNotFoundError
  end

  it "raises an exepction if the browser failed to launch" do
    skip("because headless CI") if ENV["CI"] == "true"
    caught = nil
    Launchy.open( @invalid_url, application: "browser") do |exception|
      caught = exception
    end
    _(caught).must_be_kind_of Launchy::Error
  end

  it "asssumes we open a local file if we have an exception if we have an invalid scheme and a valid path" do
    uri = "blah://example.com/#{__FILE__}"
    Launchy.open( uri , :dry_run => true )
    parts = $stdout.string.strip.split
    _(parts.size).must_be :>, 1
    _(parts.last).must_equal uri
  end

  it "opens a local file if we have a drive letter and a valid path on windows" do
    uri = "C:#{__FILE__}"
    Launchy.open( uri, :dry_run => true, :host_os => 'windows'  )
    _($stdout.string.strip).must_equal 'start launchy /b ' + uri
  end

  it "opens a data url with a forced browser application" do
    uri = "data:text/html,hello%20world"
    Launchy.open( uri, :dry_run => true, :application => "browser" )
    _($stdout.string.strip).must_match(/open/) # /usr/bin/open or xdg-open
  end

  it "calls the block if instead of raising an exception if there is an error" do
    Launchy.open( @invalid_url ) { $stderr.puts "oops had an error opening #{@invalid_url}" }
    _($stderr.string.strip).must_equal "oops had an error opening #{@invalid_url}"
  end

  it "calls the block with the values passed to launchy and the error" do
    options = { :dry_run => true }
    Launchy.open( @invalid_url, :dry_run => true ) { |e| $stderr.puts "had an error opening #{@invalid_url} with options #{options}: #{e}" }
    _($stderr.string.strip).must_equal "had an error opening #{@invalid_url} with options #{options}: No application found to handle '#{@invalid_url}'"
  end

  it "raises the error in the called block" do
    _(lambda { Launchy.open( @invalid_url ) { raise StandardError, "KABOOM!" } }).must_raise StandardError
  end

  it "can force a specific application to be used" do
    result = Launchy.open( "http://example.com", :application => "mockapplication" )
    _(result).must_equal "MockApplication opened http://example.com"
  end

  [ 'www.example.com', 'www.example.com/foo/bar', "C:#{__FILE__}" ].each do |x|
    it "picks a Browser for #{x}" do
      app = Launchy.app_for_uri_string( x )
      _(app).must_equal( Launchy::Application::Browser )
    end
  end

  it "can use a Pathname as the URI" do
    path = Pathname.new( Dir.pwd )
    app = Launchy.app_for_uri_string( path )
    _(app).must_equal( Launchy::Application::Browser )
  end

  [ "BROWSER", "bRoWsEr", "browser", "Browser" ].each do |x|
    it "can find the browser by name #{x}" do
      app = Launchy.app_for_name( x )
    _(app).must_equal( Launchy::Application::Browser )
    end
  end
end
