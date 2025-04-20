class CreateSolidCache < ActiveRecord::Migration[8.0]
  def change
    create_table "solid_cache_entries", force: :cascade do |t|
      t.binary "key", null: false
      t.binary "value", null: false
      t.datetime "created_at", null: false
      t.bigint "key_hash", null: false
      t.integer "byte_size", null: false
      t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
      t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
      t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
    end
  end
end
