require 'yaml'

describe Launchy::Detect::NixDesktopEnvironment do

 { "KDE_FULL_SESSION"         => Launchy::Detect::NixDesktopEnvironment::Kde,
   "GNOME_DESKTOP_SESSION_ID" => Launchy::Detect::NixDesktopEnvironment::Gnome }.each_pair do |k,v|
    it "can detect the desktop environment of a *nix machine using ENV[#{k}]" do
      ENV[k] = "launchy-test"
      Launchy::Detect::NixDesktopEnvironment.detect.must_equal v
      ENV.delete( k )
    end
  end
end
