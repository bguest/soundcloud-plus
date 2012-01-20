# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "soundcloud-plus/version"

Gem::Specification.new do |s|
  s.name        = "soundcloud-plus"
  s.version     = SCPlus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Benjamin Guest"]
  s.email       = ["benguest@gmaill.com"]
  s.homepage    = ""
  s.summary     = %q{Lightweight wrapper for a lightweight wrapper for the soundcloud api}
  s.description = %q{makes calling soundcloud api simpler from ruby}

  s.rubyforge_project = "soundcloud-plus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:

  # General Dependency's
  s.add_dependency "soundcloud", "~> 0.2.9"
  s.add_dependency "active_support"

  #Testing
  s.add_development_dependency "rspec"

  #Automated Testing
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
end
