module Undestroyable
  class ConnectionIsCompulsaryError < Exception; end
  class ConnectionIsAbstractError < Exception; end

  class Connection
    class << self
      attr_reader :connections, :configurations

      def set_configurations(klass, config)
        (@configurations ||= {})[klass.name] = config
      end

      def get_configurations(klass)
        if klass == Object
          (@configurations ||= {})['Undestroyable']
        else
          (@configurations ||= {})[klass.name]
        end
      end

      def [](klass_name)
        (@connections ||= {})[klass_name.to_sym]
      end

      def establish_connection(klass)
        (@connections ||= {})[klass.name] ||= create_connection(klass, get_configurations(klass))
      end

      def get_connection(klass)
        return nil if klass == Object
        if !get_configurations(klass).blank?
          self[klass.name] || establish_connection(klass)
        else
          get_connection(klass.superclass)
        end
      end

      private

      def create_connection(*opts)
        raise ConnectionIsAbstractError.new "Please use ORM specific connection"
      end
    end
  end
end