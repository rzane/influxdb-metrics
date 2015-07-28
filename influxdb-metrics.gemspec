# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'influxdb/metrics/version'

Gem::Specification.new do |spec|
  spec.name          = "influxdb-metrics"
  spec.version       = InfluxDB::Metrics::VERSION
  spec.authors       = ["Ray Zane"]
  spec.email         = ["raymondzane@gmail.com"]
  spec.summary       = %q{Track metrics for your Rails app with InfluxDB.}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7.0"
  spec.add_development_dependency "simplecov"

  spec.add_runtime_dependency "influxdb"
  spec.add_runtime_dependency "railties"
  spec.add_runtime_dependency "activesupport"
end
