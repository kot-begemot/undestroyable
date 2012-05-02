require 'active_record'
require File.expand_path("#{File.dirname(__FILE__)}/../../config")
require File.expand_path("#{File.dirname(__FILE__)}/../../data/activerecord_setup")
require File.expand_path("#{File.dirname(__FILE__)}/../../data/countries_table")

ActiveRecord::Migration.verbose = false

module ActiveRecordTest
  class ColumnSetup < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithDeletedAt.migrate(:down)
      CreateCountriesWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup { orm :active_record }
      
      Country.class_eval { undestroyable }
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :column, table_name: 'countries'}, config.configuration)
      assert_equal('countries', config[:table_name])
      assert_equal(:column, config[:strategy])
      assert_equal(true, config.column?)
    end
  end

  class ColumnOverwritten < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithDeletedAt.migrate(:down)
      CreateCountriesWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :none
      end

      Country.class_eval do
        undestroyable do
          strategy :column
        end
      end
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :column, table_name: 'countries'}, config.configuration)
      assert_equal(:column, config[:strategy])
      assert_equal(true, config.column?)
    end
  end

  class ColumnOverwritten < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithDeletedAt.migrate(:down)
      CreateCountriesWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :none
      end

      Country.class_eval do
        undestroyable do
          strategy :column
        end
      end
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :column, table_name: 'countries'}, config.configuration)
      assert_equal(:column, config[:strategy])
      assert_equal(true, config.column?)
    end
  end

  class ColumnDestroyingWithGlobalConfig < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithDeletedAt.migrate(:down)
      CreateCountriesWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :column
      end

      Country.class_eval do
        undestroyable
      end

      @country = Country.create(name: 'Netherlands', iso_3166_a2: 'NL')
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_destroy
      assert @country.destroy
      assert_equal 1, Country.unscoped.count
      assert_not_nil Country.unscoped.last.deleted_at
    end

    def test_destroy!
      @country.destroy!

      assert_equal 0, Country.unscoped.count
    end
  end

  class ColumnDestroyingWithOverwrittenConfig < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithDeletedAt.migrate(:down)
      CreateCountriesWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :none
      end

      Country.class_eval do
        undestroyable do
          strategy :column
        end
      end
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_destroy
      country = Country.create(name: 'Netherlands', iso_3166_a2: 'NL')
      country.destroy

      assert_equal 1, Country.unscoped.count
      assert_not_nil Country.unscoped.last.deleted_at
    end

    def test_destroy!
      country = Country.create(name: 'Netherlands', iso_3166_a2: 'NL')
      country.destroy!

      assert_equal 0, Country.unscoped.count
    end
  end
end