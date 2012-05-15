module Undestroyable
  module Orm
    module ActiveRecord
      class Connection < ::Undestroyable::Connection

        class << self
          def connection_handler
            @connection_handler ||= ::ActiveRecord::ConnectionAdapters::ConnectionHandler.new
          end

          def create_connection(klass, config)
            resolver = ::ActiveRecord::Base::ConnectionSpecification::Resolver.new config, Undestroyable::Connection.configurations
            spec = resolver.spec

            connection_handler.remove_connection(klass)
            connection_handler.establish_connection klass.name, spec
            connection_handler.retrieve_connection(klass)
          end
          private :create_connection
        end
      end
    end
  end
end