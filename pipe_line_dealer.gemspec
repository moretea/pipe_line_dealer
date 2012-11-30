# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pipe_line_dealer/version"

Gem::Specification.new do |s|
  s.name        = "pipe_line_dealer"
  s.version     = PipeLineDealer::VERSION
  s.authors     = ["Maarten Hoogendoorn"]
  s.email       = ["maarten@springest.com"]
  s.homepage    = "http://github.com/moretea/pipe_line_dealer"
  s.summary     = "A Ruby library that implements the PipelineDeals.com API."
  s.description = s.summary

  s.required_ruby_version = ">=1.9.2"
  
  # Dependencies
  s.add_dependency "faraday", "~> 0.8.0"
  s.add_dependency "faraday_middleware", "~> 0.9.0"
  s.add_dependency "multi_json", "~> 1.0"
  s.add_dependency "activesupport", ">= 3.2.0"

  s.add_development_dependency "debugger"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "webmock"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-inotify"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "reek"

  # Make development a charm
  if RUBY_PLATFORM.include?("darwin")
    s.add_development_dependency "growl", "~> 1.0.3"
    s.add_development_dependency "rb-fsevent"
  elsif RUBY_PLATFORM.include?("linux")
    s.add_development_dependency "rb-inotify"
  end

  # Files
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
