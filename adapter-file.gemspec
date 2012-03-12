# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adapter/file/version"

Gem::Specification.new do |s|
  s.name        = "adapter-file"
  s.version     = Adapter::File::VERSION
  s.authors     = ["Michael Fairchild"]
  s.email       = ["fairchild@stimble.net"]
  s.homepage    = ""
  s.summary     = %q{key value storage adapter to use files for persistence}
  s.description = %q{key value storage adapter to use files for persistence}

  s.rubyforge_project = "adapter-file"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "adapter"
end
