RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    FactoryBot.reload
    Sidekiq::Worker.clear_all
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.around(:each, :caching) do |spec|
    Rails.cache.clear
    caching = ActionController::Base.perform_caching
    ActionController::Base.perform_caching = spec.metadata[:caching]
    spec.run
    ActionController::Base.perform_caching = caching
  end
end
