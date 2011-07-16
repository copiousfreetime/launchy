require 'spec_helper'

describe Launchy::DetectHostOs do
  it "uses the defult host os from ruby's config" do
    Launchy::DetectHostOs.new.raw_host_os.must_equal RbConfig::CONFIG['host_os']
  end

  it "uses the passed in value as the host os" do
    Launchy::DetectHostOs.new( "fake-os-1").raw_host_os.must_equal "fake-os-1"
  end

  it "uses the environment variable LAUNCHY_HOST_OS to override ruby's config" do
    ENV['LAUNCHY_HOST_OS'] = "fake-os-2"
    Launchy::DetectHostOs.new.raw_host_os.must_equal "fake-os-2"
    ENV.delete('LAUNCHY_HOST_OS')
  end
end
