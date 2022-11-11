# frozen_string_literal: true

require_relative "lib/graphql_to_rest/version"

Gem::Specification.new do |spec|
  spec.name = "graphql_to_rest"
  spec.version = GraphqlToRest::VERSION
  spec.authors = ["Povilas Jurcys"]
  spec.email = ["po.jurcys@gmail.com"]

  spec.summary = "Allows to easily configure open api for rails application"
  spec.description = "Allows to easily configure open api for rails application"
  spec.homepage = "https://github.com/povilasjurcys/graphql_to_rest"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency 'activesupport'
  spec.add_dependency 'attr_extras', '>= 6.2.0'
  spec.add_dependency 'graphql'
  spec.add_dependency 'rails'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
