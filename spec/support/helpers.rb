require 'support/helpers/session_helpers'

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::SessionHelpers, type: :system
end
