require File.join(File.dirname(__FILE__),"spec_helper.rb")
require 'yaml'

describe "Launchy::VERSION" do
    it "should have 2 dots and have 3 numbers" do
        Launchy::VERSION.split('.').size.should == 3
        Launchy::Version.to_a.each do |n|
            n.to_i.should >= 0
        end
    end
end