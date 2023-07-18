# frozen_string_literal: true

if ENV['PARALLEL_WORKERS'].to_i != 1
  ENV['PARALLEL_WORKERS'] = '1'
  warn '**** PARALLEL_WORKERS has been disabled ****'
  warn 'SimpleCov does not support Rails Parallelization yet'
end

return if ENV['RUBYMINE_SIMPLECOV_COVERAGE_PATH']

if defined?(Spring) && ENV['DISABLE_SPRING'].nil?
  puts '**** NO COVERAGE FOR YOU! ****'
  puts 'Please disable Spring to get COVERAGE by `DISABLE_SPRING=1 COVERAGE=1 bin/rspec`'
else
  SimpleCov.start 'rails' do
    add_filter %w[
      app/views lib/jumpstart lib/rails lib/templates
      bin coverage log test vendor node_modules db doc public storage tmp
    ]

    add_group('Carriers', 'app/carriers')
    add_group('Scripts', 'app/scripts')
    # add_group("Views", "app/views")

    enable_coverage(:branch)
    enable_coverage_for_eval
  end

  parallel_number = [
    ENV['CIRCLE_NODE_INDEX'] || ENV['CI_INDEX'],
    ENV['TEST_ENV_NUMBER'] || ENV['JOB_NUMBER']
  ].compact.join('_')

  if parallel_number.present?
    SimpleCov.command_name "Job #{parallel_number}"
  end

  if ENV['COBERTURA_ENABLED']
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
end
