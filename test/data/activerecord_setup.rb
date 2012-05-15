require 'database_cleaner'
require 'logger'

DatabaseCleaner.strategy = :transaction
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ':memory:'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

module ActiveRecordSetup
  def before_setup
    DatabaseCleaner.start
  end

  def after_teardown
    DatabaseCleaner.clean
  end
end

class MigrateRedirected
  class << self
    def migrate migration, direction, redirected_connection
      migration.instance_variable_set(:@connection, redirected_connection)
      migration.send direction
    end

    def up migration, redirected_connection
      migrate migration, :up, redirected_connection
    end

    def down migration, redirected_connection
      migrate migration, :down, redirected_connection
    end
  end
end

