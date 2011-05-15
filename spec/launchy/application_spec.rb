require File.expand_path(File.join(File.dirname(__FILE__),"..","spec_helper"))
require 'yaml'

describe Launchy::Application do
  before(:each) do
    yml = YAML::load(IO.read(File.join(File.dirname(__FILE__),"..","tattle-host-os.yml")))
    @host_os = yml['host_os']
    @app = Launchy::Application.new
  end

  YAML::load(IO.read(File.join(File.dirname(__FILE__),"..", "tattle-host-os.yml")))['host_os'].keys.sort.each do |os|
    it "#{os} should be a found os" do
      Launchy::Application::known_os_families.must_include( @app.my_os_family(os) )
    end
  end

  it "should not find os of 'dos'" do
    @app.my_os_family('dos').must_equal :unknown
  end

  it "my os should have a value" do
    @app.my_os.wont_equal ''
    @app.my_os.wont_be_nil
  end

  it "should find open or curl" do
    found = %w[ open curl ].any? do |app|
      @app.find_executable(app)
    end
    found.must_equal true
  end

  it "should not find app xyzzy" do
    @app.find_executable('xyzzy').must_be_nil
  end

  it "should find the correct class to launch an ftp url" do
    Launchy::Application.find_application_class_for("ftp://ftp.ruby-lang.org/pub/ruby/").must_equal Launchy::Browser
  end

  it "knows when it cannot find an application class" do
    Launchy::Application.find_application_class_for("xyzzy:stuff,things").must_be_nil
  end

  it "allows for environmental override of host_os" do
    ENV["LAUNCHY_HOST_OS"] = "hal-9000"
    Launchy::Application.my_os.must_equal( "hal-9000" )
    ENV["LAUNCHY_HOST_OS"] = nil
  end

  { "KDE_FULL_SESSION" => :kde,
    "KDE_SESSION_UID"  => :kde,
    "GNOME_DESKTOP_SESSION_ID" => :gnome }.each_pair do |k,v|
    it "can detect the desktop environment of a *nix machine using #{k}" do
      @app.nix_desktop_environment.must_equal( :generic )
      ENV[k] = "launchy-test"
      Launchy::Application.new.nix_desktop_environment.must_equal v
      ENV[k] = nil
    end
  end
end

