# frozen_string_literal: true

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
# def add_template_repository_to_source_path
#   if __FILE__ =~ %r{\Ahttps?://}
#     require 'tmpdir'
#     source_paths.unshift(tempdir = Dir.mktmpdir('jt_tools-'))
#     at_exit { FileUtils.remove_entry(tempdir) }
#     git clone: [
#       '--quiet',
#       'https://github.com/jetthoughts/jt_tools.git',
#       tempdir
#     ].map(&:shellescape).join(' ')
#     if (branch = __FILE__[%r{jt_tools/(.+)/lib/install/template.rb}, 1])
#       Dir.chdir(tempdir) { git checkout: branch }
#     end
#   else
#     source_paths.unshift(File.dirname(__FILE__))
#   end
# end

# add_template_repository_to_source_path

# gem_group :development do
#   gem 'railties', '>= 4.2'
# end

# say 'Copying binstubs'
# directory '/lib/install/bin', 'bin'

# chmod 'bin', 0o755 & ~File.umask, verbose: false

# say 'Setup default bundle parallel jobs to 4'
# run 'bundle config jobs 4'

# say 'Copying tools gemfile'
# copy_file "#{source_paths.first}/lib/install/Gemfile.tools", 'Gemfile.tools'

# run 'yarn add -D eslint eslint-config-airbnb-base \
#   eslint-config-prettier eslint-plugin-import eslint-plugin-prettier prettier'

# run 'bin/tools-setup'

# run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub pronto'
# run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub rubocop'

# say 'Copying lint configurations'

# copy_file "#{source_paths.first}/lib/install/.better-html.yml", '.better-html.yml'
# copy_file "#{source_paths.first}/lib/install/.erb-lint.yml", '.erb-lint.yml'
# copy_file "#{source_paths.first}/lib/install/.eslintrc.js", '.eslintrc.js'
# copy_file "#{source_paths.first}/lib/install/.prettierrc", '.prettierrc'
# copy_file "#{source_paths.first}/lib/install/.pronto.yml", '.pronto.yml'
# copy_file "#{source_paths.first}/lib/install/.pronto_eslint_npm.yml", '.pronto_eslint_npm.yml'
# copy_file "#{source_paths.first}/lib/install/.rubocop.yml", '.rubocop.yml'
# copy_file "#{source_paths.first}/lib/install/.yamllint", '.yamllint'

# say 'Copying circleci configuration'
# directory "#{source_paths.first}/lib/install/.circleci", '.circleci'

# say 'Copying heroku configuration'
# copy_file "#{source_paths.first}/lib/install/app.json", 'app.json'
# copy_file "#{source_paths.first}/lib/install/Procfile", 'Procfile'
