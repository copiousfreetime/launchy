require File.join(File.dirname(__FILE__),"spec_helper.rb")

describe Launchy::Browser do
    it "should find a path to a executable" do
        File.executable?(Launchy::Browser.new.browser).should == true
    end
    
    it "should handle an http url" do
        Launchy::Browser.handle?("http://www.example.com") == true
    end
    
    it "should handle an https url" do
        Launchy::Browser.handle?("https://www.example.com") == true
    end
    
    it "should handle an ftp url" do
        Launchy::Browser.handle?("ftp://download.example.com") == true
    end
    
    it "should not handle a mailto url" do
        Launchy::Browser.handle?("mailto:jeremy@example.com") == false
    end
end