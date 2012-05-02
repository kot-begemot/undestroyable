class CreateDumpWithoutDeletedAt < ActiveRecord::Migration
  def up
    create_table(:dump) do |t|
      t.string :dump
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:dump) if @connection.schema_cache.table_exists?(:dump)
  end
end

class CreateDumpWithDeletedAt < ActiveRecord::Migration
  def up
    create_table(:dump) do |t|
      t.string :dump
      t.datetime :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:dump) if @connection.schema_cache.table_exists?(:dump)
  end
end

class CreateDumpAsScrapWithDeletedAt < ActiveRecord::Migration
  def up
    create_table(:scrap) do |t|
      t.string :dump
      t.datetime :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:scrap) if @connection.schema_cache.table_exists?(:scrap)
  end
end
