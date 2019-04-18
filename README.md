# schema2type
Using schema2type, you can generate TypeScript type definitions from Rails'schema.rb automatically.

Start with a schema.rb:

```ruby
ActiveRecord::Schema.define(version: xxxx) do
  create_table "Users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "age"
    t.bigint "sales"
    t.boolean "paid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_histories_on_patient_id"
  end
end
```

Automatically have the following TypesScript type generated

```typescript
declare namespace your_production {
  namespace schema {
    type User = {
      name: string | null
      age: number | null
      sales: number | null
      paid: boolean
      created_at: Date
      updated_at: Date
    }
  }
}
```

# Quick Start

```
git clone git@github.com:kawamataryo/schema2type.git

ruby schema2type.rb -s schema.rb -o schema.d.ts -n production_name
```
