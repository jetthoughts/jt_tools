
require 'json'

EXTRACT_DEPENDENCY_NAME = /"?(.+?)@.+?"?(?:,\s+|\Z)/.freeze
EXTRACT_DEPENDENCY_DETAILS = /(^((?!= ).*?):\n.*?(?:\n\n|\Z))/m.freeze

def direct_dependencies_names
  package_json = JSON.parse(File.open('package.json').read)
  direct_dependencies = package_json.fetch_values('dependencies', 'devDependencies', 'peerDependencies') { }
  direct_dependencies.compact.inject([]) { |memo, v| memo.concat(v.keys) }
end

@dependencies = direct_dependencies_names

yarn_lock_content = File.open('yarn.lock').read
yarn_lock_content.scan(EXTRACT_DEPENDENCY_DETAILS).each do |dependency_block|
  direct_dep = @dependencies.include?(dependency_block[1].match(EXTRACT_DEPENDENCY_NAME).to_a[1])
  puts dependency_block[0] if direct_dep
end
