require File.join(File.dirname(__FILE__),"spec_helper.rb")
require 'stringio'
describe Launchy::Browser do
  it "should find a path to a executable" do
    begin
      File.executable?(Launchy::Browser.new.browser).must_equal true
    rescue => e
      e.message.must_equal "Unable to find browser to launch for os family 'nix'."
    end
  end

  it "should handle an http url" do
    Launchy::Browser.handle?("http://www.example.com").must_equal true
  end

  it "should handle an https url" do
    Launchy::Browser.handle?("https://www.example.com").must_equal true
  end

  it "should handle an ftp url" do
    Launchy::Browser.handle?("ftp://download.example.com").must_equal true
  end

  it "should handle an file url" do
    Launchy::Browser.handle?("file:///home/user/index.html").must_equal true
  end

  it "should not handle a mailto url" do
    Launchy::Browser.handle?("mailto:jeremy@example.com").must_equal false
  end

  it "creates a default unix application list" do
    begin
      Launchy::Browser.new.nix_app_list.class.must_equal Array
    rescue => e
      e.message.must_equal "Unable to find browser to launch for os family 'nix'."
    end
  end

  { "BROWSER" => "/bin/sh",
    "LAUNCHY_BROWSER" => "/bin/sh"}.each_pair do |e,v|
    it "can use environmental variable overrides of #{e} for the browser" do
      ENV[e] = v
      Launchy::Browser.new.browser.must_equal v
      ENV[e] = nil
    end
  end

  it "reports when it cannot find an browser" do
    old_error = $stderr
    $stderr = StringIO.new
    ENV["LAUNCHY_HOST_OS"] = "testing"
    begin
      browser = Launchy::Browser.new
    rescue => e
      e.message.must_match( /Unable to find browser to launch for os family/m )
    end
    ENV["LAUNCHY_HOST_OS"] = nil
    $stderr.string.must_match( /Unable to launch. No Browser application found./m )
    $stderr = old_error
  end
end
