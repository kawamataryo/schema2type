require 'active_support/inflector'

module Schema2type
  class SchemaConverter
    attr_accessor :out_text
    attr_reader :table_name

    TYPE_STRING = 'string'.freeze
    TYPE_NUMBER = 'number'.freeze
    TYPE_BOOLEAN = 'boolean'.freeze
    TYPE_DATE = 'Date'.freeze
    COLUMN_METHODS = [
      { string: TYPE_STRING },
      { inet: TYPE_STRING },
      { integer: TYPE_NUMBER },
      { bigint: TYPE_NUMBER },
      { float: TYPE_NUMBER },
      { text: TYPE_STRING },
      { boolean: TYPE_BOOLEAN },
      { decimal: TYPE_NUMBER },
      { json: TYPE_STRING },
      { jsonb: TYPE_STRING },
      { binary: TYPE_STRING },
      { date: TYPE_DATE },
      { datetime: TYPE_DATE },
      { timestamp: TYPE_DATE },
      { datetime_with_timezone: TYPE_DATE }
    ].map(&:freeze).freeze

    def initialize(table_name:)
      @out_text = []
      @table_name = table_name.singularize.camelize
    end

    def finalize
      @out_text.unshift "type #{@table_name} = {"
      @out_text << "}\n"
    end

    def self.define_convert_methods(methods)
      methods.each do |m|
        define_method(m.keys[0]) do |name, *options|
          push_property_line name: name, type: m.values[0], options: options
        end
      end
    end

    define_convert_methods COLUMN_METHODS

    def method_missing(*arg)
      # To exclude unnecessary methods
    end

    private

    def push_property_line(name:, type:, options:)
      is_non_nullable = options[0] && options[0].key?(:null) && !options[0][:null]
      camelize_name = name.camelcase(:lower)
      property_line = is_non_nullable ? "#{camelize_name}: #{type}" : "#{camelize_name}: #{type} | null"

      @out_text << "  #{property_line}"
    end
  end
end
