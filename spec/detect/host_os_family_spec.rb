require 'spec_helper'
require 'yaml'

describe Launchy::Detect::HostOsFamily do

  before do
    Launchy.reset_global_options
  end

  after do
    Launchy.reset_global_options
  end

  YAML::load( IO.read( File.expand_path( "../../tattle-host-os.yaml", __FILE__ ) ) )['host_os'].keys.sort.each do |os|
    it "OS family of #{os} is detected" do
      Launchy::Detect::HostOsFamily.detect( os ).ancestors.must_include Launchy::Detect::HostOsFamily
    end
  end

  it "uses the global host_os overrides" do
    ENV['LAUNCHY_HOST_OS'] = "fake-os-2"
    lambda { Launchy::Detect::HostOsFamily.detect }.must_raise Launchy::Detect::HostOsFamily::NotFoundError
    ENV.delete('LAUNCHY_HOST_OS')
  end


  it "does not find an os of 'dos'" do
    lambda { Launchy::Detect::HostOsFamily.detect( 'dos' ) }.must_raise Launchy::Detect::HostOsFamily::NotFoundError
  end

end
