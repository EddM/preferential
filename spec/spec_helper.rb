require "rubygems"
require "rspec"
require "active_record"
require "factory_girl"
require "database_cleaner"
require "generator_spec"

require "preferential"

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(adapter: "sqlite3",
                                        database: ":memory:")
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../test.log")

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    require File.expand_path("../schema.rb", __FILE__)
    require File.expand_path("../models.rb", __FILE__)

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.around :each do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  FactoryGirl.factories.clear
  FactoryGirl.definition_file_paths = %w(spec/factories)
  FactoryGirl.reload
end
