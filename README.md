# schema2type
railsのschema.rbからtypescriptの型定義を作成するスクリプト

# 使い方

```
$ ruby schema2type.rb -s schema.rb -o アウトプットファイル名.ts -n ネームスペース（省略化。省略された場合 schema2typeになる）
```