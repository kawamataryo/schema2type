RSpec.describe Schema2type do
  describe '#execute' do
    INPUT_FIlE = Tempfile.open(%w(input .rb)) do |f|
      f.write <<-EOS
       ActiveRecord::Schema.define(version: 20170929125808) do
          create_table "histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
            t.string "column_string"
            t.inet "column_inet"
            t.text "column_text"
            t.json "column_json"
            t.jsonb "column_jsonb", null: false
            t.binary "column_binary", null: false
            t.integer "column_integer"
          end

          create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
            t.bigint "column_bigint"
            t.float "column_float"
            t.decimal "column_decimal"
            t.boolean "column_boolean", null: true
            t.date "column_date", null: false
            t.datetime "column_datetime"
            t.timestamp "column_timestamp"
            t.datetime_with_timezone "column_datetime_with_timezone"
            t.index ["patient_id"], name: "index_histories_on_patient_id"
          end
        end
      EOS
      f
    end
    let(:out_file) { Tempfile.new(['out.hoge.ts']) }

    context 'snake_caseがtrueの場合' do
      it 'snake_caseで変換できる' do
        Schema2type::execute(input_file: INPUT_FIlE.path, out_file: out_file.path, name_space: "hoge", is_snake_case: true)
        expect(out_file.read).to eq <<~EOS
          /* eslint no-unused-vars: 0 */

          /**
           * auto-generated file
           * schema version: 20170929125808
           * This file was automatically generated by schema2type
           */
          declare namespace hoge {
            type History = {
              column_string: string | null;
              column_inet: string | null;
              column_text: string | null;
              column_json: string | null;
              column_jsonb: string;
              column_binary: string;
              column_integer: number | null;
            }

            type User = {
              column_bigint: number | null;
              column_float: number | null;
              column_decimal: number | null;
              column_boolean: boolean | null;
              column_date: Date;
              column_datetime: Date | null;
              column_timestamp: Date | null;
              column_datetime_with_timezone: Date | null;
            }
          }
        EOS
      end
    end

    context 'snake_caseがfalseの場合' do
      it 'lowerCamelで変換できる' do
        Schema2type::execute(input_file: INPUT_FIlE.path, out_file: out_file.path, name_space: "hoge", is_snake_case: false)
        expect(out_file.read).to eq <<~EOS
          /* eslint no-unused-vars: 0 */

          /**
           * auto-generated file
           * schema version: 20170929125808
           * This file was automatically generated by schema2type
           */
          declare namespace hoge {
            type History = {
              columnString: string | null;
              columnInet: string | null;
              columnText: string | null;
              columnJson: string | null;
              columnJsonb: string;
              columnBinary: string;
              columnInteger: number | null;
            }

            type User = {
              columnBigint: number | null;
              columnFloat: number | null;
              columnDecimal: number | null;
              columnBoolean: boolean | null;
              columnDate: Date;
              columnDatetime: Date | null;
              columnTimestamp: Date | null;
              columnDatetimeWithTimezone: Date | null;
            }
          }
        EOS
      end
    end
  end
end