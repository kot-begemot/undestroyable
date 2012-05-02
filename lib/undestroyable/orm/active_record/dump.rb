module Undestroyable
  module Orm
    module ActiveRecord
      # <tt>:dump</tt> strategy is the most simple one. It requires only one table for whole project to save a data
      # in it. What it does internally, is just marshal dump an object and save it into specific table. That table
      # should have predefined format. That allows to keep an objects of different class within same table. In order
      # to change the table name, following options can be specified within configuration:
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
      # == Table structure
      #
      # [:dump]
      #   This is a text column that keepes deleted object.
      # [:deleted_at]
      #   This column keeps a time of the recodr deletion. Time is saved as UTC.
      #
      # == Example
      #
      #    Undestroyable.config do
      #      strategy :dump
      #      full_table_name :dump
      #    end
      #
      #    class Order < ActiveRecord::Base
      #      undestroyable
      #    end
      #
      #    *or*
      #
      #    class Invoice < ActiveRecord::Base
      #      undestroyable do
      #        strategy :dump
      #        table_suffix :dump
      #      end
      #    end
      #
      # +dump+ table will contain an order as an object.
      #
      # *NB!* Check out Marshal class in Ruby, for how to make this text back to object.
      module Dump

        def self.included(base)
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end

        module ClassMethods
          # Because undest_arel_table is just being ignored over there....
          def undest_mirror
            @undest_mirror ||= begin
              dump_table = ::Undestroyable::Orm::ActiveRecord::DumpTable
              dump_table.table_name = undestr_config[:full_table_name]
              dump_table.establish_connection(undestr_config[:connection]) unless undestr_config[:connection].blank?
              dump_table
            end
          end
          protected :undest_mirror
        end

        module InstanceMethods
          def destroy
            run_callbacks :destroy do
              dump_attributes = {dump: Marshal::dump(self)}
              dump_attributes.merge!(deleted_at: Time.now.utc) if self.class.send(:undest_mirror).columns_hash['deleted_at']
              self.class.send(:undest_mirror).create(dump_attributes)
              destroy!
            end
          end
        end
      end

      class DumpTable < ::ActiveRecord::Base; end
    end
  end
end