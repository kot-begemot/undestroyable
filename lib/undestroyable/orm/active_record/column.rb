module Undestroyable
  module Orm
    module ActiveRecord
      # <tt>:column</tt> strategy is the easiest among the rest. It just updates <tt>:deleted_at</tt> column
      # of the record, and set default scope conditions, to prevent its returning by default. Despite the record
      # is actually just updated, no update callback will be triggered.
      #
      # == Example
      #
      #   class ConceptCat < ActiveRecord::Base
      #     undstroyable do
      #       startegy :column
      #     end
      #   end
      #
      module Column
        def self.included(base)
          base.send :default_scope, base.where('deleted_at IS NULL')
        end

        def destroy
          run_callbacks :destroy do
            update_column :deleted_at, Time.now
          end
        end
      end
    end
  end
end