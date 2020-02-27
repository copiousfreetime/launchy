require 'spec_helper'

describe Launchy::Application::Browser do
  before do
    Launchy.reset_global_options
    ENV['KDE_FULL_SESSION'] = "launchy"
    @test_url = "http://example.com/"
  end

  after do
    Launchy.reset_global_options
    ENV.delete( 'KDE_FULL_SESSION' )
    ENV.delete( 'BROWSER' )
  end

  { 'windows' => 'start "launchy" /b' ,
    'darwin'  => [ '/usr/bin/open', '/bin/open' ], # because running tests on linux
    'cygwin'  => 'cmd /C start "launchy" /b',
    'linux'   => [nil, "xdg-open"], # because running tests on linux
  }.each  do |host_os, expected|
    it "when host_os is '#{host_os}' the appropriate 'app_list' method is called" do
      Launchy.host_os = host_os
      browser = Launchy::Application::Browser.new

      item = browser.app_list.first
      item = item.to_s if item.kind_of?(::Launchy::Argv)
      case expected
      when Array
        _(expected).must_include item
      when String
        _(item).must_equal expected
      end
    end
  end

  %w[ linux windows darwin cygwin ].each do |host_os|
    it "the BROWSER environment variable overrides any host defaults on '#{host_os}'" do
      ENV['BROWSER'] = "my_special_browser --new-tab '%s'"
      Launchy.host_os = host_os
      browser = Launchy::Application::Browser.new
      cmd, args = browser.cmd_and_args( @test_url )
      _(cmd).must_equal "my_special_browser --new-tab 'http://example.com/'"
      _(args).must_equal []
    end
  end

  it "handles a file on the file system when there is no file:// scheme" do
    uri = Addressable::URI.parse( __FILE__ )
    _(Launchy::Application::Browser.handles?( uri )).must_equal true
  end

  it "handles the case where $BROWSER is set and no *nix desktop environment is found" do
    ENV.delete( "KDE_FULL_SESSION" )
    ENV.delete( "GNOME_DESKTOP_SESSION_ID" )
    ENV['BROWSER'] = "do-this-instead"
    Launchy.host_os = 'linux'
    browser = Launchy::Application::Browser.new
    _(browser.browser_cmdline).must_equal "do-this-instead"
  end

  # NOTE: Unable to figure out how capture the stderr from the child which has
  # moved it at least once. This test just serves the purpose of noting why
  # something happens, and the problem we are attempting to fix.
  #it "When BROWSER is set to something that is not executable, error still appears on stderr" do
  #  ENV['BROWSER'] = "not-an-app"
  #  url = "http://example.com/"

  #  _, err = capture_subprocess_io do 
  #    begin
  #      Launchy.open( url )
  #    rescue => nil
  #    end
  #  end
  #  #_(err).must_match( /wibble/m )
  #  err # something
  #end
end

