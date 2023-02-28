require_relative "lib/pay_with_extend/version"

Gem::Specification.new do |spec|
  spec.name = "pay_with_extend"
  spec.version = PayWithExtend::VERSION
  spec.authors = ["Sandeep Bhatti"]
  spec.email = ["sandeep@metawarelabs.com"]

  spec.summary = %q{Extend is a Ruby gem that provides a simple interface to the Extend API.}
  spec.description = %q{Extend is a Ruby gem that provides a simple interface to the Extend API. It allows you to create virtual credit cards from Extend API.}
  spec.homepage = "https://roam.auto"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.2")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/metaware/pay_with_extend"
  spec.metadata["changelog_uri"] = "https://github.com/metaware/extend/Readme.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("pry")

  spec.add_dependency("rest-client", ">= 2.1.0")
  spec.add_dependency("jwt", "~> 2.2.2")
end
