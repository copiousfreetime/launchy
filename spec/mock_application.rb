# frozen_string_literal: true

class MockApplication < Launchy::Application
  def self.schemes
    %w[mock mockother]
  end

  def self.handles?(uri)
    schemes.include?(uri.scheme)
  end

  def open(uri, _options = {})
    "MockApplication opened #{uri}"
  end
end
