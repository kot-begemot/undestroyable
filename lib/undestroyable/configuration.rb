module Undestroyable
  
  class WrongStrategyError < Exception; end

  # Specifies which strategy to use for this configuration.
  #
  # Possible options include:
  #   [:startegy]
  #     [:none]
  #       Deletes record, as with usual destroy method. This option may be used as a cancelation
  #       of undestoyable state of record, for STI model as an example.
  #     [:column]
  #       Updates <tt>:deleted_at</tt> column of the record. This is default strategy,
  #       in cafe if undestroyable is specified for model.
  #     [:table]
  #       Move record into separate table.
  #     [:database]
  #       Move table into separate database.
  #     [:dump]
  #       Marshal dump all deleted records into common table table.
  #   [:table_name]
  #     Keep alternative to table name. By default it will equivalent to one used by Model backend.
  #     It is ignored by <tt>:none</tt> and <tt>::column</tt> strategies.
  #   [:table_prefix]
  #     Keep table prefix. If it is set not nil, it will be ignored for table creation. Default is nil.
  #     It is ignored by <tt>:none</tt> and <tt>::column</tt> strategies.
  #   [:table_suffix]
  #     Keep table suffix. If it is set not nil, it will be ignored for table creation. Default is nil.
  #     It is ignored by <tt>:none</tt> and <tt>::column</tt> strategies.
  #   [:full_table_name]
  #     Keep full table name. If this field is not specified it will be generated from 
  #     table_name + table_prefix + table_suffix.
  #     It is ignored by <tt>:none</tt> and <tt>::column</tt> strategies.
  #   [:connection]
  #     Keep credetial information for remote database connection.
  #     *NB!* Compulsary for :database strategy, ignored for rest strategies.
  #
  # == EXAMPLES
  #
  #   class ConceptCat < ActiveRecord::Base
  #     undstroyable do
  #       startegy :table
  #       table_name :metalic
  #       table_suffix :scrap
  #     end
  #   end
  #
  #   class ConceptCat < ActiveRecord::Base
  #     undstroyable do
  #       startegy :database
  #       connection {}
  #       table_name :scrap
  #     end
  #   end
  #
  #  class ConceptCat < ActiveRecord::Base
  #    undstroyable do
  #      startegy :dump
  #      table_name :scrap
  #    end
  #  end
  #
  class Configuration
    
    attr_reader :configuration

    def initialize(opts = {},&block)
      copy_system = opts[:copy_system].nil? ? true : opts.delete(:copy_system)
      @configuration ||= (copy_system ? Undestroyable.config.configuration.dup : {})
      @configuration[:strategy] ||= :column
      prepare &block if block_given?
    end

    def prepare &block
      instance_eval &block
      raise(::Undestroyable::ConnectionIsCompulsaryError.new "Connection information is compulsary") if database? && get_connection_settings.blank?
    end
    alias_method :setup, :prepare

    #[:strategy, :table_name, :table_suffix, :full_table_name, :connection]

    ::Undestroyable::STRATEGIES.each do |strategy|
      define_method "#{strategy}?" do
        configuration[:strategy] == strategy
      end
    end

    # Allows to access <tt>configuration</tt> values via provided keys.
    # Example:
    #
    #   c = Undestroyable.config
    #   c[:strategy] # => :column
    def [](option_name)
      # :full_table_name will be generated on first request
      generate_full_name if option_name == :full_table_name && !configuration[:full_table_name]
      configuration[option_name]
    end

    def strategy(shrtkey)
      raise WrongStrategyError.new(%Q{Such strategy "#{shrtkey}" does not exists.}) unless ::Undestroyable::STRATEGIES.include? shrtkey.to_sym
      table_name('dump') if shrtkey.to_sym == :dump && !@configuration[:table_name]
      @configuration[:strategy] = shrtkey.to_sym
    end

    %w(table_name table_prefix table_suffix full_table_name connection).each do |parameter|
      define_method parameter do |param_value|
        @configuration[parameter.to_sym] = param_value
      end
    end

    def get_connection_settings
      @configuration[:connection]
    end

    private

    def generate_full_name
      if @configuration[:table_prefix] || @configuration[:table_name] || @configuration[:table_suffix]
        table_name = "#{@configuration[:table_prefix].to_s}_" if @configuration[:table_prefix]
        (table_name ||= '') << @configuration[:table_name].to_s
        table_name << "_#{@configuration[:table_suffix].to_s}" if @configuration[:table_suffix]
        @configuration[:full_table_name] = table_name.to_sym
      end
    end

  end
end