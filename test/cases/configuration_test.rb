require File.expand_path("#{File.dirname(__FILE__)}/../config")

class ConfigurationTest < Test::Unit::TestCase
  def setup
    Undestroyable.instance_variable_set :@config, nil
  end

  def test_class_methods
    config = Undestroyable.config.configuration

    assert_equal({:strategy=>:column}, config)
    assert_equal(:column, config[:strategy])
  end

  def test_basic_setup
    Undestroyable.config.setup do
      strategy :table
    end

    assert_equal({:strategy=>:table}, Undestroyable.config.configuration)
    assert_equal(true, Undestroyable.config.table?)
    assert_equal(:table, Undestroyable.config[:strategy])
  end

  def test_full_setup
    Undestroyable.config.setup do
      strategy :database
      connection :test => "One"
      table_name :scrap
    end

    assert_equal({strategy: :database, :connection=>{test: "One"}, table_name: :scrap}, Undestroyable.config.configuration)
    assert_equal(true, Undestroyable.config.database?)
    assert_equal(:database, Undestroyable.config[:strategy])
    assert_equal({:test => "One"}, Undestroyable.config[:connection])
    assert_equal(:scrap, Undestroyable.config[:table_name])
  end

  def test_table_name_generation
    Undestroyable.config.setup do
      strategy :table
      table_prefix :test
      table_name :scrap
      table_suffix :metalic
    end

    assert_equal(:test_scrap_metalic, Undestroyable.config[:full_table_name])
  end

  def test_table_prefix_generation
    Undestroyable.config.setup do
      strategy :table
      table_prefix :test
      table_name :scrap
    end

    assert_equal(:test_scrap, Undestroyable.config[:full_table_name])
  end

  def test_table_prefix_generation
    Undestroyable.config.setup do
      strategy :table
      table_name :scrap
      table_suffix :metalic
    end

    assert_equal(:scrap_metalic, Undestroyable.config[:full_table_name])
  end
end