require 'yaml'
require 'active_support/inflector'

module Schema2type
  class SchemaConverter
    attr_reader :property_lines, :table_name, :is_snake_case

    COLUMN_METHODS = YAML.load_file(File.expand_path(__dir__) + '/conversion_table.yml').to_a
    ID_PROPERTY_LINE_TEXT = "  id: number;".freeze

    def self.define_convert_methods(methods)
      methods.each do |m|
        define_method(m[0]) do |name, *options|
          convert_property_line_and_push name: name, type: m[1], options: options
        end
      end
    end

    define_convert_methods COLUMN_METHODS

    def initialize(table_name:, is_snake_case: false)
      @property_lines = []
      @table_name = table_name.singularize.camelize
      @is_snake_case = is_snake_case
    end

    def converted_type_lines
      ["type #{table_name} = {", ID_PROPERTY_LINE_TEXT, property_lines, "}\n"].flatten
    end

    def method_missing(*)
      # To exclude unnecessary methods
      # TODO: add error handling
    end

    private

    def convert_property_line_and_push(name:, type:, options:)
      is_non_nullable = options[0] && options[0].key?(:null) && !options[0][:null]
      formatted_name = is_snake_case ? name.underscore : name.camelcase(:lower)
      property_line = is_non_nullable ? "#{formatted_name}: #{type};" : "#{formatted_name}: #{type} | null;"

      property_lines << "  #{property_line}"
    end
  end
end
