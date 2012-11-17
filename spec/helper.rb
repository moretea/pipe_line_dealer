Bundler.setup

unless ENV["NO_COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "spec"
  end
end

require "pipe_line_dealer"
require "webmock/rspec"
require "reek/spec"

# Load support files
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.filter_run focus: true

  # Do not run the acceptance tests by default.
  if ENV["ACCEPTANCE"] == "true"
    puts "Running acceptance specs!"
    AcceptanceHelper.check_api_key!
  else
    puts "Skipping acceptance specs"
    config.filter_run_excluding acceptance: true
  end

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.include Reek::Spec
end
