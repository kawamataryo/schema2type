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
      it 'optionsにnull: falseを含まない場合、null許容型のプロパティ宣言を配列にプラスする' do
        sc.send(:push_property_line, name: 'name', type: 'strong', options: [{ null: true }])
        expect(sc.out_text[0]).to eq('  name: strong | null')
      end
      it 'optionsにnull: falseを含む場合、null非許容型のプロパティ宣言を配列にプラスする' do
        sc.send(:push_property_line, name: 'name', type: 'strong', options: [{ null: false }])
        expect(sc.out_text[0]).to eq('  name: strong')
      end
    end

    describe 'property_methods' do
      Schema2type::SchemaConverter::COLUMN_METHODS.each do |m|
        it "#{m.keys[0]}メソッドは#{m.values[0]}を型に設定すること" do
          sc.send(m.keys[0], 'column')
          expect(sc.out_text[0]).to eq(%(  column: #{m.values[0]} | null))
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
