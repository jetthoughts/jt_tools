# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jt_tools/version'

Gem::Specification.new do |spec|
  spec.name = 'jt_tools'
  spec.version = JtTools::VERSION
  spec.authors = ['Paul Keen']
  spec.email = ['pftg@users.noreply.github.com']

  spec.summary = 'Setup development scripts to manage code base effectively'
  spec.description = 'Helpful scripts to run linters locally and on CI'
  spec.homepage = 'https://jtway.co'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jetthoughts/jt-tools/'
  spec.metadata['changelog_uri'] = 'https://github.com/jetthoughts/jt-tools/'

  spec.add_dependency 'railties', '>= 4.2'
  spec.add_development_dependency 'bump'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']
end
