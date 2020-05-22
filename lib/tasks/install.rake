# frozen_string_literal: true

install_template_path = File.expand_path("../../template.rb", __dir__).freeze
bin_path = ENV["BUNDLE_BIN"] || "./bin"

namespace :jt_tools do
  desc "Install jt-tools in this application"
  task install: :environment do
    exec "#{RbConfig.ruby} #{bin_path}/rails app:template LOCATION=#{install_template_path}"
  end
end
