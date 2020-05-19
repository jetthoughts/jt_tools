# frozen_string_literal: true

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__.match?(%r{\Ahttps?://})
    require 'shellwords'
    require 'tmpdir'

    source_paths.unshift(temp_dir = Dir.mktmpdir('jt_tools-'))
    at_exit { FileUtils.remove_entry(temp_dir) }
    git clone: [
      '--quiet',
      'https://github.com/jetthoughts/jt_tools.git',
      temp_dir
    ].map { |args| Shellwords.escape(args) }
      .join(' ')

    if (branch = __FILE__[%r{jt_tools/(.+)/template.rb}, 1])
      Dir.chdir(temp_dir) { git checkout: branch }
    end
  else
    source_paths.unshift(__dir__)
  end
end

add_template_repository_to_source_path

say '=> Copying binstubs'
directory 'lib/install/bin', 'bin'

chmod 'bin', 0o755 & ~File.umask, verbose: false

say '=> Copying tools gemfile'
copy_file 'lib/install/Gemfile.tools', 'Gemfile.tools'

run 'yarn add -D eslint'

say 'Copying lint configurations'
copy_file 'lib/install/.better-html.yml', '.better-html.yml'
copy_file 'lib/install/.erb-lint.yml', '.erb-lint.yml'
copy_file 'lib/install/.eslintrc.js', '.eslintrc.js'
copy_file 'lib/install/.pronto.yml', '.pronto.yml'
copy_file 'lib/install/.pronto_eslint_npm.yml', '.pronto_eslint_npm.yml'
copy_file 'lib/install/.rubocop.yml', '.rubocop.yml'
copy_file 'lib/install/.yamllint.yml', '.yamllint.yml'
copy_file 'lib/install/.reek.yml', '.reek.yml'
copy_file 'lib/install/config/rails_best_practices.yml', 'config/rails_best_practices.yml'
copy_file 'lib/install/.editorconfig', '.editorconfig'

say '=> Copying services configuration'
copy_file 'lib/install/.simplecov', '.simplecov'
copy_file 'lib/install/codecov.yml', 'codecov.yml'


say '=> Adds service client API gems'

gem_group :test do
  gem 'simplecov', require: false, group: :test
  gem 'codecov', require: false, group: :test
end

gem 'oj'

gem_group :production, :staging do
  gem 'rollbar'
  gem 'le'
end

directory 'lib/install/.circleci', '.circleci'

if File.read('Gemfile').include? 'rspec'
  gem 'rspec_junit_formatter', require: false, group: :test
  insert_into_file(
    'spec/spec_helper.rb',
    "require 'simplecov' if ENV['COVERAGE']\n",
    after: /\A/
  )
else
  gem 'minitest-ci', require: false, group: :test
  insert_into_file(
    'test/test_helper.rb',
    "require 'simplecov' if ENV['COVERAGE']\n",
    after: /\A/
  )
end

directory 'lib/install/.dependabot', '.dependabot'

say '=> Copying heroku configuration'
copy_file 'lib/install/app.json', 'app.json'
copy_file 'lib/install/Procfile', 'Procfile'

say '=> Install Brew dependencies'
copy_file 'lib/install/Brewfile', 'Brewfile'

say 'Setup git hooks'
directory 'lib/install/bin/git-hooks', 'bin/git-hooks'

require 'bundler'
Bundler.with_original_env do
  say '=> Install tools'
  run 'bin/tools-setup'

  say '=> Generate binstubs for linters'
  run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub --force pronto'
  run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub --force rubocop'
end

say '=> Set git hooks'
run 'git config core.hooksPath ./bin/git-hooks'

say '=> Install all new dependencies'
run <<~BREW_INSTALL
  hash brew 2> /dev/null \
  && (brew bundle check || brew bundle install) \
  || echo "Please install Homebrew: https://brew.sh/"
BREW_INSTALL

say '=> Update development config'
uncomment_lines 'config/environments/development.rb', /config\.file_watcher = ActiveSupport::EventedFileUpdateChecker/

after_bundle do
  say '=> Setup default bundle config'
  run 'bundle config jobs 4'
  run 'bundle config retry 3'
end

say '**************************************************************************'
say '**************************************************************************'
say ''
say '1. Recommended Heroku Addons: Mailtrap, Rollbar, Cloudinary'
say ''
say '2. Setup Git Hooks to auto-check code and cleanup staled branches'
say '$ `cp bin/git-hooks/pre-push.sample bin/git-hooks/pre-push`'
say '$ `cp bin/git-hooks/post-merge.sample bin/git-hooks/post-merge`'
say ''
say '3. Please, set CODECOV_TOKEN, GITHUB_TOKEN and PRONTO_GITHUB_ACCESS_TOKEN'
say 'environment variables in CircleCI and your local env'
say ''
say '   For code coverage report aggregator, running code static analysis'
say 'and auto-update of the tools.'
say ''
say '**************************************************************************'
say '**************************************************************************'
