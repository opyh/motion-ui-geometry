# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-ui-geometry/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sebastian Burkhart"]
  gem.email         = ["sebastianburkhart@me.com"]
  gem.description   = %q{Access CoreGraphics UI geometry the Ruby way.}
  gem.summary       = %q{Contains Ruby-ish interfaces mixed into Float, CGPoint, CGRect, CGSize and CGPoint.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "motion-ui-geometry"
  gem.require_paths = ["lib"]
  gem.version       = Motion::UI::Geometry::VERSION
end
