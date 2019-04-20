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
declare namespace schema {
  type User = {
    name: string | null
    age: number | null
    sales: number | null
    paid: boolean
    createdAt: Date
    updatedAt: Date
  }
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'schema2type'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install schema2type
    


## Usage

```
bundle exec schema2type -s db/schema.rb -o schema.d.ts -n schema
```

#### options

|command | require | default | detail |
|---|---|---|---|
| -s | true | - | Path of your schema.rb  |
| -o | true | - | Output file name of TypeScript |
| -n | false | "schema" | Name of declare namespace |
| --snake | false | false | Convert property name to snake_case |

#### conversion table

|create_table block method| converted Type|
|---|---|
| string | string |
| text | string |
| json | string |
| jsonb | string |
| binary | string |
| inet | string |
| integer | number |
| bigint | number |
| float | number |
| decimal | number |
| boolean | boolean |
| date | Date |
| datetime | Date |
| timestamp | Date |
| datetime_with_timezone | Date |
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


