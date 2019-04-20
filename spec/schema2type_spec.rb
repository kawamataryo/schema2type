RSpec.describe Schema2type do
  describe '::SchemaConverter' do
    let(:sc) { Schema2type::SchemaConverter.new(table_name: 'users') }

    it 'テーブル名を単数形のキャメルケースに変換すること' do
      expect(sc.table_name).to eq 'User'
    end

    describe '#finalize' do
      it 'out_textの先頭に"type table_name = {"、末尾に"}\n"を加えること' do
        sc.finalize
        expect(sc.out_text).to eq(['type User = {', "}\n"])
      end
    end

    describe '#push_property_line' do
      context 'optionsにnull: falseを含まない場合' do
        it 'null許容型のプロパティ宣言を配列にプラスする' do
          sc.send(:push_property_line, name: 'name', type: 'strong', options: [{ null: true }])
          expect(sc.out_text[0]).to eq('  name: strong | null')
        end
      end
      context 'optionsにnull: falseを含む場合' do
        it 'optionsにnull: falseを含む場合、null非許容型のプロパティ宣言を配列にプラスする' do
          sc.send(:push_property_line, name: 'name', type: 'strong', options: [{ null: false }])
          expect(sc.out_text[0]).to eq('  name: strong')
        end
      end
      context 'snake_caseがfalseの場合' do
        let(:sc_not_snake) do
          Schema2type::SchemaConverter.new(table_name: 'users', snake_case: false)
        end
        it 'lowerCamelでプロパティ名を設定すること' do
          p sc_not_snake
          sc_not_snake.send(:push_property_line, name: 'user_name', type: 'strong', options: [])
          expect(sc_not_snake.out_text[0]).to eq('  userName: strong | null')
        end
      end
      context 'snake_caseがtrueの場合' do
        let(:sc_snake) do
          Schema2type::SchemaConverter.new(table_name: 'users', snake_case: true)
        end
        it 'snake_caseでプロパティ名を設定すること' do
          sc_snake.send(:push_property_line, name: 'userName', type: 'strong', options: [])
          expect(sc_snake.out_text[0]).to eq('  user_name: strong | null')
        end
      end
    end

    describe 'property_methods' do
      Schema2type::SchemaConverter::COLUMN_METHODS.each do |m|
        it "#{m[0]}メソッドは#{m[1]}を型に設定すること" do
          sc.send(m[0], 'column')
          expect(sc.out_text[0]).to eq(%(  column: #{m[1]} | null))
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
end
