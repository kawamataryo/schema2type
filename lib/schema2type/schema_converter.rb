require 'yaml'
require 'active_support/inflector'

module Schema2type
  class SchemaConverter
    attr_reader :property_lines, :table_name, :convertion_table, :snake_case

    TYPE_STRING = 'string'.freeze
    TYPE_NUMBER = 'number'.freeze
    TYPE_BOOLEAN = 'boolean'.freeze
    TYPE_DATE = 'Date'.freeze
    COLUMN_METHODS = YAML.load_file(File.expand_path(__dir__) + '/conversion_table.yml').to_a

    def self.define_convert_methods(methods)
      methods.each do |m|
        define_method(m[0]) do |name, *options|
          push_property_line name: name, type: m[1], options: options
        end
      end
    end

    define_convert_methods COLUMN_METHODS

    def initialize(table_name:, snake_case: false)
      @property_lines = []
      @table_name = table_name.singularize.camelize
      @snake_case = snake_case
    end

    def result
      ["type #{table_name} = {", property_lines, "}\n"].flatten
    end

    def method_missing(*)
      # To exclude unnecessary methods
    end

    private

    def push_property_line(name:, type:, options:)
      is_non_nullable = options[0] && options[0].key?(:null) && !options[0][:null]
      formatted_name = snake_case ? name.underscore : name.camelcase(:lower)
      property_line = is_non_nullable ? "#{formatted_name}: #{type};" : "#{formatted_name}: #{type} | null;"

      property_lines << "  #{property_line}"
    end
  end
end
