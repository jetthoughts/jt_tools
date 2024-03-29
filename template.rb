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

run 'yarn add -D eslint jest-junit'

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
  gem 'simplecov-cobertura', require: false, group: :test
  gem 'rexml', require: false, group: :test # for hot fix of webdrivers and ruby 3
end

gem 'oj'

gem_group :production, :staging do
  gem 'dalli'
  gem 'r7insight'
  gem 'rollbar'
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
  gsub_file 'test/test_helper.rb',
    'parallelize(workers: :number_of_processors)',
    "parallelize(workers: :number_of_processors) unless ENV['COVERAGE']"
end

say '=> Copying git configuration'
directory 'lib/install/.github', '.github'
if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1.0')
  gitattributes = <<~GITATTRIBUTES
    *.gemspec diff=ruby
    *.rake    diff=ruby
    *.rb      diff=ruby
    *.js      diff=javascript
  
    db/schema.rb merge=ours diff=ruby
    yarn.lock merge=ours
    Gemfile.lock merge=ours linguist-generated
  GITATTRIBUTES
  insert_into_file '.gitattributes', gitattributes
else
  copy_file 'lib/install/.gitattributes', '.gitattributes'
end

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
  run 'BUNDLE_GEMFILE=Gemfile.tools bundle lock --add-platform x86_64-linux'

  say '=> Generate binstubs for linters'
  run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub --force pronto'
  run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub --force rubocop'
  run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub --force standard'
end

say '=> Set git hooks'
run 'git config core.hooksPath ./bin/git-hooks'
say '=> Install all new dependencies'

run <<~BREW_INSTALL
  hash brew 2> /dev/null \
  && (brew bundle check || brew bundle install --no-lock) \
  || echo "Please install Homebrew: https://brew.sh/"
BREW_INSTALL

say '=> Update development config'
uncomment_lines(
  'config/environments/development.rb',
  /config\.file_watcher = ActiveSupport::EventedFileUpdateChecker/
)

say '=> Set up R7Insight'
r7insight_config = <<-CODE
  if ENV['R7INSIGHT_TOKEN'].present?
    Rails.logger = R7Insight.new(ENV['R7INSIGHT_TOKEN'], ENV['R7INSIGHT_REGION'])
  end
CODE
insert_into_file 'config/environments/production.rb',
  "require 'r7_insight.rb'" + "\n\n",
  before: 'Rails.application.configure do'
environment(r7insight_config, env: 'production')
if File.exist?('config/environments/staging.rb')
  insert_into_file 'config/environments/staging.rb',
    "require 'r7_insight.rb'" + "\n\n",
    before: 'Rails.application.configure do'
  environment(r7insight_config, env: 'staging')
end

gem 'connection_pool'

say '=> Set up Memcachier'
memcachier_config = <<-CODE
  if ENV["MEMCACHIER_SERVERS"]
    config.cache_store = :mem_cache_store,
      ENV["MEMCACHIER_SERVERS"].split(","), {
        username: ENV["MEMCACHIER_USERNAME"], password: ENV["MEMCACHIER_PASSWORD"],
        failover: true, socket_timeout: 1.5, socket_failure_delay: 0.2, down_retry_delay: 60,
        pool_size: ENV.fetch("RAILS_MAX_THREADS") { 5 },
      }
  end

CODE
environment(memcachier_config, env: 'production')
if File.exist?('config/environments/staging.rb')
  environment(memcachier_config, env: 'staging')
end

Bundler.with_original_env do
  say '=> Setup default bundle config'
  run 'bundle config jobs 4'
  run 'bundle config retry 3'

  run 'bundle'

  run 'bundle lock --add-platform x86_64-linux'
end

uncomment_lines 'bin/setup', /system\(.*?\\byarn\b/

insert_into_file(
  'bin/setup',
  "system! 'bin/tools-setup'\n",
  after: "system! 'gem install bundler --conservative'\n"
)

say '**************************************************************************'
say '**************************************************************************'
say ''
say '1. Recommended Heroku Addons: Mailtrap, Rollbar, Cloudinary'
say ''
say '2. Setup Git Hooks to auto-check code and cleanup staled branches:'
say '$ `git config core.hooksPath bin/git-hooks`'
say ''
say '3. Please, set CODECOV_TOKEN, GITHUB_TOKEN and PRONTO_GITHUB_ACCESS_TOKEN'
say 'environment variables in CircleCI and your local env'
say ''
say '   For code coverage report aggregator, running code static analysis'
say 'and auto-update of the tools.'
say ''
say '**************************************************************************'
say '**************************************************************************'
