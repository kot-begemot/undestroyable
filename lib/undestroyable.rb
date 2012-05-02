module Undestroyable
  autoload :Configuration, 'undestroyable/configuration'
  autoload :STRATEGIES, 'undestroyable/strategies'
  autoload :VERSION, 'undestroyable/version'

  require 'undestroyable/orm'

  module Orm
    autoload :ActiveRecord, 'undestroyable/orm/active_record'
  end

  def self.config
    @config ||= Configuration.new(copy_system: false).tap do |c|
      def c.orm(orm_type)
        constant = Undestroyable::Orm
        loadable = Orm.get_by_key(orm_type)
        constant.const_defined?(loadable) ? constant.const_get(loadable) : constant.const_missing(loadable)
      end
    end
  end
end