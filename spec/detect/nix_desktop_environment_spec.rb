require 'spec_helper'

describe Launchy::Detect::NixDesktopEnvironment do

  before do
    Launchy.reset_global_options
  end

  after do
    Launchy.reset_global_options
  end


  { "KDE_FULL_SESSION"         => Launchy::Detect::NixDesktopEnvironment::Kde,
    "GNOME_DESKTOP_SESSION_ID" => Launchy::Detect::NixDesktopEnvironment::Gnome }.each_pair do |k,v|
    it "can detect the desktop environment of a *nix machine using ENV[#{k}]" do
      ENV[k] = "launchy-test"
      nix_env = Launchy::Detect::NixDesktopEnvironment.detect
      nix_env.must_equal( v )
      nix_env.browser.must_equal( v.browser )
      ENV.delete( k )
    end
   end

  it "returns xdg as the default linux desktop environment" do
    Launchy.host_os = "linux"
    xdg_env = Launchy::Detect::NixDesktopEnvironment.detect
    xdg_env.must_equal( Launchy::Detect::NixDesktopEnvironment::Xdg )
    xdg_env.browser.must_equal( Launchy::Detect::NixDesktopEnvironment::Xdg.browser )
  end

  it "returns false for XFCE if xprop is not found" do
    Launchy.host_os = "linux"
    Launchy::Detect::NixDesktopEnvironment::Xfce.is_current_desktop_environment?.must_equal( false )
  end
end
