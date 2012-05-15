require 'active_record'

module Undestroyable
  module Orm
    module ActiveRecord
      autoload :Connection, 'undestroyable/orm/active_record/connection'
      autoload :Column,     'undestroyable/orm/active_record/column'
      autoload :Table,      'undestroyable/orm/active_record/table'
      autoload :Database,   'undestroyable/orm/active_record/database'
      autoload :Dump,       'undestroyable/orm/active_record/dump'

      def self.included(base)
        base.instance_eval { alias_method :destroy!, :destroy }
        base.extend ClassMethods
      end

      module ClassMethods
        def undestroyable &block
          undestr_config(&block) unless @undestr_config
          undestr_config.table_name(table_name) unless undestr_config[:table_name]
          undestr_include_startegy
          ::Undestroyable::Orm::ActiveRecord::Connection.set_configurations(self, undestr_config.get_connection_settings) if undestr_config.get_connection_settings
          undestr_config
        end

        protected

        def undestr_include_startegy
          undestr_strategy = undestr_config[:strategy]
          if Undestroyable::STRATEGIES.include? undestr_strategy
            if undestr_config.none?
              #nothing should happen for this strategy.
            else
              include "Undestroyable::Orm::ActiveRecord::#{undestr_strategy.to_s.classify}".constantize
            end
          end
        end

        # Keeps undestroyable configuration for class.
        def undestr_config &block
          @undestr_config ||= Undestroyable::Configuration.new(&block)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Undestroyable::Orm::ActiveRecord