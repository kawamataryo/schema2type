require "active_support/inflector"

module Schema2type
  class SchemaConverter
    attr_accessor :out_text
    attr_reader :table_name

    TYPE_STRING = "string".freeze
    TYPE_NUMBER = "number".freeze
    TYPE_BOOLEAN = "string".freeze
    TYPE_DATE = "Date".freeze

    def initialize(table_name:)
      @out_text = []
      @table_name = table_name.singularize.camelize
    end

    def finalize
      @out_text.unshift "type #{@table_name} = {"
      @out_text << "}\n"
    end

    def string(name, *options)
      push_property_line name: name, type: TYPE_STRING, options: options
    end

    def inet(name, *options)
      push_property_line name: name, type: TYPE_STRING, options: options
    end

    def text(name, *options)
      push_property_line name: name, type: TYPE_STRING, options: options
    end

    def json(name, *options)
      push_property_line name: name, type: TYPE_STRING, options: options
    end

    def jsonb(name, *options)
      push_property_line name: name, type: TYPE_STRING, options: options
    end

    def binary(name, *options)
      push_property_line name: name, type: TYPE_STRING, options: options
    end

    def integer(name, *options)
      push_property_line name: name, type: TYPE_NUMBER, options: options
    end

    def bigint(name, *options)
      push_property_line name: name, type: TYPE_NUMBER, options: options
    end

    def float(name, *options)
      push_property_line name: name, type: TYPE_NUMBER, options: options
    end

    def boolean(name, *options)
      push_property_line name: name, type: TYPE_BOOLEAN, options: options
    end

    def decimal(name, *options)
      push_property_line name: name, type: TYPE_NUMBER, options: options
    end

    def date(name, *options)
      push_property_line name: name, type: TYPE_DATE, options: options
    end

    def datetime(name, *options)
      push_property_line name: name, type: TYPE_DATE, options: options
    end

    def timestamp(name, *options)
      push_property_line name: name, type: TYPE_DATE, options: options
    end

    def datetime_with_timezone(name, *options)
      push_property_line name: name, type: TYPE_DATE, options: options
    end

    def method_missing(*arg)
      # To exclude unnecessary methods
    end

    private

    def push_property_line(name:, type:, options:)
      is_non_nullable = options[0] && options[0].has_key?(:null) && !options[0][:null]
      camelizeName = name.camelcase(:lower)
      property_line = is_non_nullable ? "#{camelizeName}: #{type}" : "#{camelizeName}: #{type} | null"

      @out_text << "  #{property_line}"
    end
  end
end
