require 'capybara/rails'
require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end
end

Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.default_normalize_ws = true
end
