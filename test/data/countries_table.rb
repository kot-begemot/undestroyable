class CreateCountriesWithoutDeletedAt < ActiveRecord::Migration
  def up
    create_table(:countries) do |t|
      t.string :name
      t.string :iso_3166_a2
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:countries) if @connection.schema_cache.table_exists?(:countries)
  end
end

class CreateCountriesWithDeletedAt < ActiveRecord::Migration
  def up
    create_table(:countries) do |t|
      t.string :name
      t.string :iso_3166_a2
      t.timestamp :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:countries) if @connection.schema_cache.table_exists?(:countries)
  end
end

class CreateCountriesWithPrefix < ActiveRecord::Migration
  def up
    create_table(:alpha_countries) do |t|
      t.string :name
      t.string :iso_3166_a2
      t.timestamp :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:alpha_countries) if @connection.schema_cache.table_exists?(:alpha_countries)
  end
end

class CreateCountriesWithSuffix < ActiveRecord::Migration
  def up
    create_table(:countries_deleted) do |t|
      t.string :name
      t.string :iso_3166_a2
      t.timestamp :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:countries_deleted) if @connection.schema_cache.table_exists?(:countries_deleted)
  end
end

class CreateCountriesWithPrefixAndSuffix < ActiveRecord::Migration
  def up
    create_table(:alpha_countries_deleted) do |t|
      t.string :name
      t.string :iso_3166_a2
      t.timestamp :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:alpha_countries_deleted) if @connection.schema_cache.table_exists?(:alpha_countries_deleted)
  end
end

class CreateScapAsCountries < ActiveRecord::Migration
  def up
    create_table(:scrap) do |t|
      t.string :name
      t.string :iso_3166_a2
      t.timestamp :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:scrap) if @connection.schema_cache.table_exists?(:scrap)
  end
end

class CreateScapAsCountriesWithPrefixAndSuffix < ActiveRecord::Migration
  def change
    create_table(:alpha_scrap_deleted) do |t|
      t.string :name
      t.string :iso_3166_a2
      t.timestamp :deleted_at
    end
  end

  def down
    @connection.schema_cache.clear!
    drop_table(:alpha_scrap_deleted) if @connection.schema_cache.table_exists?(:alpha_scrap_deleted)
  end
end