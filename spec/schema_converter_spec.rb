RSpec.describe 'SchemaConverter' do
  let(:sc) { Schema2type::SchemaConverter.new(table_name: 'users') }

  it 'テーブル名を単数形のキャメルケースに変換すること' do
    expect(sc.table_name).to eq 'User'
  end

  describe '#result' do
    it 'out_textの先頭に"type table_name = {", "id: number\n"、末尾に"}\n"を加えること' do
      sc.send(:convert_property_line_and_push, name: 'name', type: 'strong', options: [{ null: true }])
      expect(sc.converted_type_lines).to eq(['type User = {', "  id: number;", '  name: strong | null;', "}\n"])
    end
  end

  describe '#push_property_line' do
    context 'optionsにnull: falseを含まない場合' do
      it 'null許容型のプロパティ宣言を配列にプラスする' do
        sc.send(:convert_property_line_and_push, name: 'name', type: 'strong', options: [{ null: true }])
        expect(sc.property_lines[0]).to eq('  name: strong | null;')
      end
    end
    context 'optionsにnull: falseを含む場合' do
      it 'optionsにnull: falseを含む場合、null非許容型のプロパティ宣言を配列にプラスする' do
        sc.send(:convert_property_line_and_push, name: 'name', type: 'strong', options: [{ null: false }])
        expect(sc.property_lines[0]).to eq('  name: strong;')
      end
    end
    context 'snake_caseがfalseの場合' do
      let(:sc_not_snake) do
        Schema2type::SchemaConverter.new(table_name: 'users', is_snake_case: false)
      end
      it 'lowerCamelでプロパティ名を設定すること' do
        p sc_not_snake
        sc_not_snake.send(:convert_property_line_and_push, name: 'user_name', type: 'strong', options: [])
        expect(sc_not_snake.property_lines[0]).to eq('  userName: strong | null;')
      end
    end
    context 'snake_caseがtrueの場合' do
      let(:sc_snake) do
        Schema2type::SchemaConverter.new(table_name: 'users', is_snake_case: true)
      end
      it 'snake_caseでプロパティ名を設定すること' do
        sc_snake.send(:convert_property_line_and_push, name: 'userName', type: 'strong', options: [])
        expect(sc_snake.property_lines[0]).to eq('  user_name: strong | null;')
      end
    end
  end

  describe 'property_methods' do
    Schema2type::SchemaConverter::COLUMN_METHODS.each do |m|
      it "#{m[0]}メソッドは#{m[1]}を型に設定すること" do
        sc.send(m[0], 'column')
        expect(sc.property_lines[0]).to eq(%(  column: #{m[1]} | null;))
      end
    end
  end

  describe '#method_missing' do
    it '不明なメソッドが呼ばれたときでもErrorをNoMethodsErrorが発生しないこと' do
      expect { sc.hogehoge }.not_to raise_error
      expect { sc.fuggfgg }.not_to raise_error
      expect { sc.dfkdsfsfdsaf }.not_to raise_error
      expect { sc.fdsadsfsadfafsa }.not_to raise_error
    end
  end
end
