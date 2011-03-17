require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) ) 

require 'launchy/paths'

describe Launchy::Paths do
  it "can access the root dir of the project" do
    answer = File.expand_path( File.join( File.dirname( __FILE__ ), ".." ) ) + ::File::SEPARATOR
    Launchy::Paths.root_dir.must_equal answer
  end

  %w[ lib ].each do |sub|
    it "can access the #{sub} path of the project" do
      answer = File.expand_path( File.join( File.dirname( __FILE__ ), "..", sub ) ) + ::File::SEPARATOR
      Launchy::Paths.send("#{sub}_path" ).must_equal answer
    end
  end
end
