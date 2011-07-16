require 'spec_helper'
require 'yaml'

describe Launchy::Detect::HostOsFamily do

  YAML::load( IO.read( File.expand_path( "../../tattle-host-os.yaml", __FILE__ ) ) )['host_os'].keys.sort.each do |os|
    it "OS family of #{os} is detected" do
      Launchy::Detect::HostOsFamily.new( os ).host_os_family.wont_equal Launchy::Detect::HostOsFamily::Unknown
      #Launchy::Detect::HostOsFamily.new( os ).host_os_family.must_equal Launchy::Detect::HostOsFamily::Unknown
    end
  end

  it "uses the global host_os overrides" do
    ENV['LAUNCHY_HOST_OS'] = "fake-os-2"
    Launchy::Detect::HostOsFamily.new.host_os_family.must_equal Launchy::Detect::HostOsFamily::Unknown
    ENV.delete('LAUNCHY_HOST_OS')
  end


  it "does not find an os of 'dos'" do
    Launchy::Detect::HostOsFamily.new( 'dos' ).host_os_family.must_equal Launchy::Detect::HostOsFamily::Unknown
  end

end
