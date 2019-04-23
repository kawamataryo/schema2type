module Schema2type
  class CovertService
    def initialize(is_snake_case)
      @converted_types = []
      @is_snake_case = is_snake_case
    end

    def get_binding
      binding
    end

    # mock method for create_table in schema.rb
    def convert_schema_to_type(table_name, *)
      converter = SchemaConverter.new(table_name: table_name, is_snake_case: @is_snake_case)
      yield converter
      @converted_types.concat converter.converted_type_lines
    end

    def method_missing(*)
      # To exclude unnecessary methods
      # TODO: add error handling
    end

    def self.method_missing(*)
      # To exclude unnecessary methods
      # TODO: add error handling
    end

    # mock module and method for shcema.rb
    module ActiveRecord
      module Schema
        def self.define(*arg)
          converted_types = yield
          converted_type_lines = converted_types.map { |t| "  #{t}" }.join("\n").strip
          {
            lines: converted_type_lines,
            version: arg[0][:version]
          }
        end
      end
    end

    alias create_table convert_schema_to_type
  end
end
