require File.join(File.dirname(__FILE__),"spec_helper.rb")

describe Launchy::Spawnable::Browser do
    it "should find a path to a executable" do
        File.executable?(Launchy::Spawnable::Browser.new.browser).should == true
    end
    
    it "should handle an http url" do
        Launchy::Spawnable::Browser.handle?("http://www.example.com") == true
    end
    
    it "should handle an https url" do
        Launchy::Spawnable::Browser.handle?("https://www.example.com") == true
    end
    
    it "should handle an ftp url" do
        Launchy::Spawnable::Browser.handle?("ftp://download.example.com") == true
    end
    
    it "should not handle a mailto url" do
        Launchy::Spawnable::Browser.handle?("mailto:jeremy@example.com") == false
    end
end