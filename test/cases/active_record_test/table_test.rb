require 'active_record'
require File.expand_path("#{File.dirname(__FILE__)}/../../config")
require File.expand_path("#{File.dirname(__FILE__)}/../../data/activerecord_setup")
require File.expand_path("#{File.dirname(__FILE__)}/../../data/countries_table")

ActiveRecord::Migration.verbose = false

module ActiveRecordTest
  class TableOverwritten < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithoutDeletedAt.migrate(:down)
      CreateCountriesWithoutDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :column
      end

      Country.class_eval do
        undestroyable do
          strategy :table
        end
      end
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :table, table_name: 'countries'}, config.configuration)
      assert_equal(:table, config[:strategy])
      assert_equal(true, config.table?)
    end
  end

  class TableInheritedOptions < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithoutDeletedAt.migrate(:down)
      CreateCountriesWithoutDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        table_prefix :table
        table_suffix :old
      end

      Country.class_eval do
        undestroyable do
          strategy :table
        end
      end
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :table, table_name: 'countries', table_prefix: :table,table_suffix: :old}, config.configuration)
      assert_equal(:table_countries_old, config[:full_table_name])
      assert_equal({strategy: :table, table_name: 'countries', table_suffix: :old, table_prefix: :table, full_table_name: :table_countries_old}, config.configuration)
      assert_equal(true, config.table?)
    end
  end

  class TableInheritedOptionsWithOwerwrittenName < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithoutDeletedAt.migrate(:down)
      CreateCountriesWithoutDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        table_prefix :table
        table_suffix :old
      end

      Country.class_eval do
        undestroyable do
          strategy :table
          table_name :scrap
        end
      end
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :table, table_name: :scrap, table_prefix: :table,table_suffix: :old}, config.configuration)
      assert_equal(:table_scrap_old, config[:full_table_name])
      assert_equal(true, config.table?)
    end
  end

  class TableDestroyWithGlobalConfig < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateCountriesWithoutDeletedAt.migrate(:down)
      CreateCountriesWithoutDeletedAt.migrate(:up)
      CreateCountriesWithSuffix.migrate(:down)
      CreateCountriesWithSuffix.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :table
        table_suffix :deleted
      end

      Country.class_eval do
        undestroyable
      end
    end

    def test_destroy
      country = Country.create(name: 'Netherlands', iso_3166_a2: 'NL')
      country.destroy

      value = Country.unscoped.last
      undest_value = Country.send(:undest_mirror).last

      assert_nil value
      assert_not_nil undest_value
      undest_value_attributes = undest_value.attributes
      deleted_at_value = undest_value_attributes.delete('deleted_at')
      assert_equal country.attributes, undest_value_attributes
      assert_not_nil deleted_at_value
    end

    def test_destroy!
      country = Country.create(name: 'Netherlands', iso_3166_a2: 'NL')
      country.destroy!

      value = Country.unscoped.last
      undest_value = Country.undest_relation.last

      assert_nil value
      assert_nil undest_value
    end
  end
end