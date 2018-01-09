ENV['RAILS_ENV'] ||= 'test'

ENGINE_ROOT = File.join(File.dirname(__FILE__), '../')

# Load environment.rb from the dummy app.
require File.expand_path('../dummy/config/environment',  __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner'

# Load RSpec helpers.
Dir[File.join(ENGINE_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

# Load migrations from the dummy app.
ActiveRecord::Migrator.migrations_paths = File.join(ENGINE_ROOT, 'spec/dummy/db/migrate')
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
