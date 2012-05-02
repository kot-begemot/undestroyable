require 'active_record'
require File.expand_path("#{File.dirname(__FILE__)}/../../config")
require File.expand_path("#{File.dirname(__FILE__)}/../../data/activerecord_setup")
require File.expand_path("#{File.dirname(__FILE__)}/../../data/dump_table")

ActiveRecord::Migration.verbose = false

module ActiveRecordTest
  class DumpOverwritten < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateDumpWithoutDeletedAt.migrate(:down)
      CreateDumpWithoutDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        strategy :column
      end

      Country.class_eval do
        undestroyable do
          strategy :dump
        end
      end
    end

    def tear_down
      Country.instance_variable_set :@undestr_config, nil
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :dump, table_name: 'dump'}, config.configuration)
      assert_equal(:dump, config[:strategy])
      assert_equal(true, config.dump?)
    end
  end

  class DumpInheritedOptions < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateDumpWithoutDeletedAt.migrate(:down)
      CreateDumpWithoutDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
        table_prefix :table
        table_suffix :old
      end

      Country.class_eval do
        undestroyable do
          strategy :dump
        end
      end
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :dump, table_name: 'dump', table_prefix: :table,table_suffix: :old}, config.configuration)
      assert_equal(:table_dump_old, config[:full_table_name])
      assert_equal({strategy: :dump, table_name: 'dump', table_suffix: :old, table_prefix: :table, full_table_name: :table_dump_old}, config.configuration)
      assert_equal(true, config.dump?)
    end
  end

  class DumpInheritedOptionsWithOwerwrittenName < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateDumpAsScrapWithDeletedAt.migrate(:down)
      CreateDumpAsScrapWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm :active_record
      end

      Country.class_eval do
        undestroyable do
          strategy :dump
          table_name :scrap
        end
      end
    end

    def test_default_strategy
      config = Country.instance_variable_get(:@undestr_config)

      assert_equal({strategy: :dump, table_name: :scrap}, config.configuration)
      assert_equal(:scrap, config[:full_table_name])
      assert_equal({strategy: :dump, table_name: :scrap, full_table_name: :scrap}, config.configuration)
      assert_equal(true, config.dump?)
    end
  end

  class DumpDestroyWithGlobalConfig < Test::Unit::TestCase
    include ActiveRecordSetup

    class Country < ActiveRecord::Base
      validates :name, :presence => true
    end

    def setup
      CreateDumpWithDeletedAt.migrate(:down)
      CreateDumpWithDeletedAt.migrate(:up)

      Undestroyable.instance_variable_set :@config, nil
      Undestroyable.config.setup do
        orm           :active_record
        strategy      :dump
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
      deleted_at_value = undest_value.attributes.delete('deleted_at')
      assert_equal country, Marshal::load(undest_value.dump)
      assert_not_nil deleted_at_value
    end

    def test_destroy!
      country = Country.create(name: 'Netherlands', iso_3166_a2: 'NL')
      country.destroy!

      value = Country.unscoped.last
      undest_value = Country.send(:undest_mirror).last

      assert_nil value
      assert_nil undest_value
    end
  end
end