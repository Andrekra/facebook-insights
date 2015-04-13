# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebook_insights/version'

Gem::Specification.new do |spec|
  spec.name          = "facebook_insights"
  spec.version       = FacebookInsights::VERSION
  spec.authors       = ["Andre Kramer"]
  spec.email         = ["andre@panofy.com"]
  spec.summary       = %q{A gem that gets statistics about a users facebook page.}
  spec.description   = %q{Providing a authentication token, this gem attemps to
                          get statistics of the user. For example, the reach, subscribers, likes,
                          geographic information.
                        }
  spec.homepage      = "http://wirelab.nl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency "koala"
end
