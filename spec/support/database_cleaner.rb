# DatabaseCleaner configuration as described here: http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
RSpec.configure do |config|
  
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  # end
  #
  # config.before(:each) do |example|
  #   DatabaseCleaner.strategy = if example.metadata[:js] ||
  #                                 example.metadata[:chrome] ||
  #                                 example.metadata[:selenium]
  #                                :truncation # Otherwise we get an SQLite3::BusyException because more than one thread try to modify the database, see http://stackoverflow.com/questions/12326096
  #                              else
  #                                :transaction
  #                              end
  #
  #   DatabaseCleaner.start
  # end
  #
  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
end

# To make chrome driver work, we need to monkey patch active record, otherwise we get an "SQLite3::BusyException: database is locked". See http://stackoverflow.com/questions/29387097.
# class ActiveRecord::Base
#   mattr_accessor :shared_connection
#   @@shared_connection = nil
#
#   def self.connection
#     @@shared_connection || retrieve_connection
#   end
# end
# ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection




# RSpec.configure do |config|
#
# # This says that before the entire test suite runs, clear the test database out completely. This gets rid of any garbage left over from interrupted or poorly-written tests—a common source of surprising test behavior.
#   config.before(:suite) do
#     DatabaseCleaner.clean_with(:truncation)
#   end
#
# # This part sets the default database cleaning strategy to be transactions. Transactions are very fast, and for all the tests where they do work—that is, any test where the entire test runs in the RSpec process—they are preferable.
#   config.before(:each) do
#     DatabaseCleaner.strategy = :transaction
#   end
#
# # This line only runs before examples which have been flagged :js => true. By default, these are the only tests for which Capybara fires up a test server process and drives an actual browser window via the Selenium backend. For these types of tests, transactions won’t work, so this code overrides the setting and chooses the “truncation” strategy instead.
#   config.before(:each, :js => true) do
#     DatabaseCleaner.strategy = :truncation
#     FactoryGirl.reload
#   end
#
#   config.before(:each) do
#     DatabaseCleaner.start
#   end
#
# # These lines hook up database_cleaner around the beginning and end of each test, telling it to execute whatever cleanup strategy we selected beforehand.
#   config.append_after(:each) do
#     DatabaseCleaner.clean
#   end
#
# end









# config.around(:example) do |example|
#   unless example.metadata[:noclean]
#     DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
#     DatabaseCleaner.cleaning do
#       example.run
#     end
#   end
# end
#
# config.before(:context, :noclean => true) do |example_group|
#   DatabaseCleaner.strategy = example_group.class.metadata[:js] ? :truncation : :transaction
#   DatabaseCleaner.start
# end
#
# config.after(:context, :noclean => true) do
#   DatabaseCleaner.clean
# end




# config.before(:suite) do
#   DatabaseCleaner.strategy = :transaction
#   DatabaseCleaner.clean_with(:truncation)
# end
#
# config.around(:each) do |example|
#   DatabaseCleaner.cleaning do
#     example.run
#   end
# end



# config.expect_with :rspec do |expectations|
#   # Enable only the newer, non-monkey-patching expect syntax.
#   # For more details, see:
#   #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
#   expectations.syntax = [:should, :expect]
# end
#
# config.mock_with :mocha

# config.before(:suite) do
#   DatabaseCleaner.strategy = :truncation
# end
#
# config.before(:each) do
#   DatabaseCleaner.start
# end
#
# config.before(:each, :js => true) do
#   DatabaseCleaner.strategy = :truncation
# end
#
# config.after(:each) do
#   DatabaseCleaner.clean
# end
