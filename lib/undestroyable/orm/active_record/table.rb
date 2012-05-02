module Undestroyable
  module Orm
    module ActiveRecord
      # <tt>:table</tt> strategy will save any deleted record within separate table. By default, it will use
      # same naming as a actual table. In order to change the table name, following options can be specified
      # within configuration:
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
      module Table
        def self.included(base)
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end

        module ClassMethods
          def undest_arel_table
            @undest_table ||= ::Arel::Table.new(undestr_config[:full_table_name], self)
          end

          def undest_relation
            @undest_relation ||= ::ActiveRecord::Relation.new(undest_mirror, undest_arel_table)
          end

          # Because undest_arel_table is just being ignored over there.... 
          def undest_mirror
            @undest_mirror ||= begin
              copy = self.dup
              copy.table_name = undestr_config[:full_table_name]
              copy
            end
          end
          protected :undest_mirror
        end

        module InstanceMethods
          def destroy
            run_callbacks :destroy do
              deleted_attributes = undest_compile_insert_attributes
              deleted_attributes << [self.class.undest_arel_table['deleted_at'], Time.now.utc]
              self.class.undest_relation.insert deleted_attributes
              destroy!
            end
          end

          def undest_compile_insert_attributes
            attributes.map do |key, value|
              [self.class.undest_arel_table[key], value]
            end
          end

          protected :undest_compile_insert_attributes
        end
      end
    end
  end
end