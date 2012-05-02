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
          # Because undest_arel_table is just being ignored over there....
          def undest_mirror
            @undest_mirror ||= begin
              copy = self.dup
              copy.table_name = undestr_config[:full_table_name]
              def copy.name; undestr_config[:full_table_name].to_s.classify; end
              copy.establish_connection undestr_config[:connection]
              copy
            end
          end
          protected :undest_mirror
        end

        module InstanceMethods
          def destroy
            run_callbacks :destroy do
              deleted_attributes = undest_compile_insert_attributes
              deleted_attributes << [self.class.undest_arel_table['deleted_at'], Time.now.utc] if self.class.send(:undest_mirror).columns_hash['deleted_at']
              self.class.undest_relation.insert deleted_attributes
              destroy!
            end
          end
        end
      end
    end
  end
end