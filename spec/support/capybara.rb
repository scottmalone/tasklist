require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/webkit/matchers'
require 'capybara/email/rspec'
require 'selenium-webdriver'
require 'webdrivers'

Capybara.server = :puma, { Silent: true }
Capybara.default_selector = :css
Capybara.default_max_wait_time = 10
Capybara.javascript_driver = :headless_chrome

options = Selenium::WebDriver::Chrome::Options.new

if ENV['HEADED']
  options.add_argument('auto-open-devtools-for-tabs') if ENV['CHROME_DEVTOOLS']
  options.add_argument('no-sandbox')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1980,1080')
else # Running headless
  options.add_argument('headless')
end

# Issue with Net::ReadTimeout in Chrome
# https://github.com/teamcapybara/capybara/issues/2181
options.add_argument('enable-features=NetworkService,NetworkServiceInProcess')

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

RSpec.configure do |config|
  config.around(:each, type: :system) do |example|
    driven_by :chrome

    allow_urls = [
      %r{chromedriver.storage.googleapis.com},
    ]

    WebMock.disable_net_connect!(
      allow: [
        lambda{|uri| uri.host.length % 2 == 0 },
        *allow_urls
      ],
      allow_localhost: true
    )

    example.run

    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
