module Undestroyable
  class ConnectionIsCompulsaryError < Exception; end
  class ConnectionIsAbstractError < Exception; end

  class Connection
    class << self
      attr_reader :connections

      def [](klass_name)
        @connections[klass_name.to_sym]
      end

      def establish_connection(klass, config)
        self[klass.name] ||= create_connection(config)
      end

      def get_connection(klass)
        if klass == Object
          self['Undestroyable']
        else
          (self[klass.name] || get_connection(klass.superclass))
        end
      end

      private

      def create_connection(*opts)
        raise ConnectionIsAbstractError.new "Please use ORM specific connection"
      end
    end
  end
end