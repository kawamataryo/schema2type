require 'optparse'
require './src/schema_converter'

params = ARGV.getopts('s:o:n:')

INPUT_FILE = params["s"]
OUT_FILE = params["o"]
NAME_SPACE = params["n"]

$convert_types = []

def create_table(table_name, *arg, &block)
  converter = SchemaConverter.new(table_name: table_name)
  block.call(converter)
  converter.finalize

  $convert_types.concat(converter.out_text)
end

module ActiveRecord
  class Schema
    def self.define(version, &block)
      block.call
    end
  end
end

eval(File.read(INPUT_FILE))

name_space = NAME_SPACE ? NAME_SPACE : "schema"
convert_type_text =
    $convert_types.map { |t| "  #{t}" }.join("\n").strip

File.open(OUT_FILE, "w") do |f|
  CONVERT_TEXT = <<-EOS
declare namespace #{name_space} {
  #{convert_type_text}
}
  EOS
  f.puts CONVERT_TEXT
end


