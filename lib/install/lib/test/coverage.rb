if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start 'rails' do
    add_group 'Workers', 'app/workers'
    add_group 'Reports', 'app/reports'
    add_group 'Interactors', 'app/interactors'
  end

  if ENV['CODECOV_TOKEN']
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  end
end
