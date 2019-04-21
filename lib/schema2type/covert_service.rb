module Schema2type
  class CovertService
    def initialize(snake_case)
      @converted_types = []
      @snake_case = snake_case
    end

    def get_binding
      binding
    end

    def create_table(table_name, *)
      converter = SchemaConverter.new(table_name: table_name, snake_case: @snake_case)
      yield converter
      @converted_types.concat converter.result
    end

    def method_missing(*)
      # To exclude unnecessary methods
    end

    def self.method_missing(*)
      # To exclude unnecessary methods
    end

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
  end
end
