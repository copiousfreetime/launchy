class MockApplication < Launchy::Application
  def self.schemes
    %w[ mock mockother ]
  end

  def self.handles?( uri )
    schemes.include?( uri.scheme )
  end

  def open( uri, options = {} )
    return "MockApplication opened #{uri}"
  end
end
