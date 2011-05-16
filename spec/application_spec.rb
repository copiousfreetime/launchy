require 'spec_helper'
require 'mock_scheme'

class JunkApp < Launchy::Application
  def self.schemes
    %w[ junk ]
  end
end

describe Launchy::Application do
  it 'registers inherited classes' do
    class Junk2App < Launchy::Application
      def self.schemes
        %w[ junk2 ]
      end
    end
    Launchy::Application.application_list.must_include( Junk2App )
    Launchy::Application.application_list.delete( Junk2App )
  end

  it "can find an app" do
    Launchy::Application.application_list.must_include( JunkApp )
    Launchy::Application.scheme_list.size.must_equal 3
    Launchy::Application.for_scheme( "junk" ).must_equal( JunkApp  )
  end

  it "raises an error if an application cannot be found for the given scheme" do
    lambda { Launchy::Application.for_scheme( "foo" ) }.must_raise( Launchy::SchemeNotFoundError )
  end
end
