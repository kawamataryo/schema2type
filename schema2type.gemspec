
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "schema2type/version"

Gem::Specification.new do |spec|
  spec.name          = "schema2type"
  spec.version       = Schema2type::VERSION
  spec.authors       = ["ryo"]
  spec.email         = ["ba068082@gmail.com"]

  spec.summary       = %q{generate TypeScript type definitions from Rails schema.rb}
  spec.description   = %q{Using schema2type, you can generate TypeScript type definitions from Rails'schema.rb automatically.}
  spec.homepage      = "https://github.com/kawamataryo/schema2type"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
