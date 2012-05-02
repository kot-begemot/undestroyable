require File.expand_path("#{File.dirname(__FILE__)}/../../config")

module ActiveRecordTest
  class LoadingBeforeTest < Test::Unit::TestCase
    def test_loading
      assert ActiveRecord::Base.include? Undestroyable::Orm::ActiveRecord
    end
  end
end

module ActiveRecordTest
  class LoadingAfterTest < Test::Unit::TestCase
    def setup
      Undestroyable.config.setup do
        orm :active_record
      end
    end

    def test_loading
      assert ActiveRecord::Base.include? Undestroyable::Orm::ActiveRecord
    end
  end
end