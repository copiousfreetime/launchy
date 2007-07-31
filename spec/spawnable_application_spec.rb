require File.join(File.dirname(__FILE__),"spec_helper.rb")
require 'yaml'

describe Launchy::Spawnable::Application do
    before(:each) do
        yml = YAML::load(IO.read(File.join(File.dirname(__FILE__),"tattle-host-os.yml")))
        @host_os = yml['host_os']
        @app = Launchy::Spawnable::Application.new
        
    end

    it "should find all tattled os" do
        @host_os.keys.each do |os|
            Launchy::Spawnable::Application::KNOWN_OS_FAMILIES.should include(@app.my_os_family(os))
        end
    end
    
    it "should not find os of 'dos'" do
        @app.my_os_family('dos').should == :unknown
    end
    
    it "my os should have a value" do
        @app.my_os.should_not == ''
        @app.my_os.should_not == nil
    end 
    
    it "should find open" do    
        @app.find_executable('open').should == "/usr/bin/open"
    end
    
    it "should not find app xyzzy" do
        @app.find_executable('xyzzy').should == nil
    end
    
    it "should find the correct class to launch an ftp url" do
        Launchy::Spawnable::Application.find_application_class_for("ftp://download.fedora.redhat.com").should == Launchy::Spawnable::Browser
    end
end
