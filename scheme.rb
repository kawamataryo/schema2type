ActiveRecord::Schema.define(version: 20170929125808) do
  create_table "histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "history_date"
    t.string "patient_name"
    t.integer "sales"
    t.bigint "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_histories_on_patient_id"
  end

  create_table "patients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "kana"
    t.string "sex"
    t.date "birthdate"
    t.string "phone"
    t.integer "post_code"
    t.string "address"
    t.string "reason"
    t.string "experience"
    t.date "firstday"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "patient_id"
    t.string "email"
    t.string "symptom"
    t.index ["deleted_at"], name: "index_patients_on_deleted_at"
  end
end

