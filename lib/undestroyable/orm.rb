module Undestroyable
  module Orm
    SUPPORTED = %(ActiveRecord).freeze

    class UnexisingOrmError < RuntimeError; end

    def Orm.get_by_key(key)
      case key.to_sym
      when :active_record
        'ActiveRecord'
      else
        raise UnexisingOrmError.new "No orm matching: :#{key.to_s}"
      end
    end
  end
end