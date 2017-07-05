root_dir = File.expand_path(File.dirname(__FILE__) + "/..")
Dir["#{root_dir}/lib/**/*.rb"].each { |f| require f }

require "rspec-power_assert"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
