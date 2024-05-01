# frozen_string_literal: true

# vim: syntax=ruby
load "tasks/this.rb"

This.name     = "launchy"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "https://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_dependency("addressable", "~> 2.8")
  spec.add_dependency("childprocess", "~> 5.0")

  spec.licenses = ["ISC"]

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/copiousfreetime/launchy/issues",
    "changelog_uri"   => "https://github.com/copiousfreetime/launchy/blob/master/HISTORY.md",
    "homepage_uri"    => "https://github.com/copiousfreetime/launchy",
    "source_code_uri" => "https://github.com/copiousfreetime/launchy",
  }
end

load "tasks/default.rake"
