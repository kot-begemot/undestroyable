module Undestroyable
  module Orm
    module ActiveRecord
      class Connection < ::Undestroyable::Connection

        def create_connection(config)
          raise ConnectionIsAbstractError.new ""
        end
         private :create_connection
         
      end
    end
  end
end