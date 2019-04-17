require "active_support/inflector"

def create_table(table_name, *arg, &block)
  columns = Columns.new(table_name: table_name)
  block.call(columns)
  text = columns.out_text
  text.push "    }"
  text.push ""

  File.open(ARGV[1], "a") do |out|
    text.each {|line| out.puts line}
  end
end

class Columns
  attr_accessor :out_text

  def initialize(table_name:)
    @out_text = []
    @out_text.push "    type #{table_name.singularize.camelize} = {"
  end

  def date(name, *options)
    write_column name: name, type: "string", options: options
  end

  def string(name, *options)
    write_column name: name, type: "string", options: options
  end

  def integer(name, *options)
    write_column name: name, type: "number", options: options
  end

  def bigint(name, *options)
    write_column name: name, type: "number", options: options
  end

  def datetime(name, *options)
    write_column name: name, type: "string", options: options
  end

  def text(name, *options)
    write_column name: name, type: "string", options: options
  end

  def boolean(name, *options)
    write_column name: name, type: "boolean", options: options
  end

  def decimal(name, *options)
    write_column name: name, type: "number", options: options
  end

  def json(name, *options)
    write_column name: name, type: "string", options: options
  end

  def binary(name, *options)
    write_column name: name, type: "string", options: options
  end

  def timestamp(name, *options)
    write_column name: name, type: "string", options: options
  end

  def index(*arg)
  end

  private

  def write_column(name:, type:, options:)
    is_non_nullable = options.include?({ :null => false })
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


File.open(ARGV[1], "w") do |f|
  init_text = <<-EOS
declare namespace misoca {

  /**
   * DBに紐づく型定義
   */
  namespace schema {

EOS
  f.puts init_text
end

eval(File.read(ARGV[0]))

File.open(ARGV[1], "a") do |f|
  init_text = <<-EOS
  }
}
EOS
  f.puts init_text
end
