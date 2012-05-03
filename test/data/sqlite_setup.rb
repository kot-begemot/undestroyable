require 'sqlite3'

class SqliteSetup
  TEST_DATABASE_PATH = File.expand_path("#{File.dirname(__FILE__)}/../temp/test.db").freeze

  def self.create_db
    SQLite3::Database.new TEST_DATABASE_PATH
  end
end