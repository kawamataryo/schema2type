require "active_support/inflector"
require 'optparse'

params = ARGV.getopts('s:o:n:')

$INPUT_FILE = params["s"]
$OUT_FILE = params["o"]
$NAME_SPACE = params["n"]

def create_table(table_name, *arg, &block)
  converter = TypeConverter.new(table_name: table_name)
  block.call(converter)
  text = converter.out_text
  text.push "    }"
  text.push ""

  File.open($OUT_FILE, "a") do |out|
    text.each {|line| out.puts line}
  end
end

class TypeConverter
  attr_accessor :out_text

  TYPE_STRING = "string"
  TYPE_NUMBER = "number"
  TYPE_BOOLEAN = "string"
  TYPE_OBJECT = "object"

  def initialize(table_name:)
    @out_text = []
    @out_text.push "    type #{table_name.singularize.camelize} = {"
  end

  def date(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def string(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def integer(name, *options)
    write_type name: name, type: TYPE_NUMBER, options: options
  end

  def bigint(name, *options)
    write_type name: name, type: TYPE_NUMBER, options: options
  end

  def datetime(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def text(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def boolean(name, *options)
    write_type name: name, type: TYPE_BOOLEAN, options: options
  end

  def decimal(name, *options)
    write_type name: name, type: TYPE_NUMBER, options: options
  end

  def json(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def binary(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def timestamp(name, *options)
    write_type name: name, type: TYPE_STRING, options: options
  end

  def index(*arg)
  end

  private

    def write_type(name:, type:, options:)
      is_non_nullable = options[0] && options[0].has_key?(:null) && !options[0][:null]
      if is_non_nullable
        @out_text.push "      #{name}: #{type}"
      else
        @out_text.push "      #{name}: #{type} | null"
      end
    end
end

module ActiveRecord
  class Schema
    def self.define(version, &block)
      block.call
    end
  end
end


File.open($OUT_FILE, "w") do |f|
  INIT_TEXT = <<-EOS
declare namespace #{$NAME_SPACE ? $NAME_SPACE : "schema2type"} {
  namespace schema {

EOS
  f.puts INIT_TEXT
end

eval(File.read($INPUT_FILE))

File.open($OUT_FILE, "a") do |f|
  init_text = <<-EOS
  }
}
EOS
  f.puts init_text
end
