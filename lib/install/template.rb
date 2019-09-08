# frozen_string_literal: true

say 'Copying binstubs'
directory "#{__dir__}/bin", 'bin'

chmod 'bin', 0o755 & ~File.umask, verbose: false

say 'Setup default bundle parallel jobs to 4'
run 'bundle config jobs 4'

say 'Copying tools gemfile'
copy_file "#{__dir__}/Gemfile.tools", 'Gemfile.tools'

run 'yarn add -D eslint eslint-config-airbnb-base \
  eslint-config-prettier eslint-plugin-import eslint-plugin-prettier prettier'

run 'bin/tools-setup'

run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub pronto'
run 'BUNDLE_GEMFILE=Gemfile.tools bundle binstub rubocop'

say 'Copying lint configurations'

copy_file "#{__dir__}/.better-html.yml", '.better-html.yml'
copy_file "#{__dir__}/.erb-lint.yml", '.erb-lint.yml'
copy_file "#{__dir__}/.eslintrc.js", '.eslintrc.js'
copy_file "#{__dir__}/.prettierrc", '.prettierrc'
copy_file "#{__dir__}/.pronto.yml", '.pronto.yml'
copy_file "#{__dir__}/.pronto_eslint_npm.yml", '.pronto_eslint_npm.yml'
copy_file "#{__dir__}/.rubocop.yml", '.rubocop.yml'
copy_file "#{__dir__}/.yamllint", '.yamllint'

say 'Copying circleci configuration'
directory "#{__dir__}/.circleci", '.circleci'

say 'Copying heroku configuration'
copy_file "#{__dir__}/app.json", 'app.json'
copy_file "#{__dir__}/Procfile", 'Procfile'
