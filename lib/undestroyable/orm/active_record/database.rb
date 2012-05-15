module Undestroyable
  module Orm
    module ActiveRecord
      # <tt>:database</tt> strategy will save any deleted record within remote database. <tt>:connection</tt> option
      # *is required*. By default, it will use same naming as a actual table. In order to change the table name,
      # following options can be specified within configuration:
      #
      #   [:table_name]
      #     Keep alternative to table name. By default it will equivalent to one used by Model backend.
      #   [:table_prefix]
      #     Keep table prefix. If it is set not nil, it will be ignored for table creation. Default is nil.
      #   [:table_suffix]
      #     Keep table suffix. If it is set not nil, it will be ignored for table creation. Default is nil.
      #   [:full_table_name]
      #     Keep full table name. If this field is not specified it will be generated from
      #     table_name + table_prefix + table_suffix.
      #
      # == Example
      #
      #   class ConceptCat < ActiveRecord::Base
      #     undstroyable do
      #       startegy :database
      #       connection { adapter: "sqlite3", dbfile: ":memory:"}
      #       table_name :scrap
      #       table_suffix :metalic
      #     end
      #   end
      #
      module Database

        def self.included(base)
          base.send :include, Table
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end

        module ClassMethods
          def undest_relation
            # something about connection here
            @undest_relation ||= begin
              relation = ::ActiveRecord::Relation.new(self, undest_arel_table)
              def relation.connection
                undest_connection
              end
              relation
            end
          end

          def undest_connection
            @undest_connection ||= ::Undestroyable::Orm::ActiveRecord::Connection.get_connection(self)
          end
        end

        module InstanceMethods
          def destroy
            run_callbacks :destroy do
              deleted_attributes = undest_compile_insert_attributes
              if self.class.connection.column_exists? self.class.send(:undestr_config)[:full_table_name], 'deleted_at'
                deleted_attributes << [self.class.undest_arel_table['deleted_at'], Time.now.utc]
              end
              self.class.undest_relation.insert deleted_attributes
              destroy!
            end
          end
        end
      end
    end
  end
end