# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_26_062844) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "object_types", force: :cascade do |t|
    t.string "type_id", null: false
    t.jsonb "definition", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_object_types_on_deleted_at"
    t.index ["type_id"], name: "index_object_types_on_type_id", unique: true
  end

  create_table "resources", force: :cascade do |t|
    t.string "object_type", null: false
    t.string "object_id", null: false
    t.jsonb "meta", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_resources_on_deleted_at"
    t.index ["object_type", "object_id"], name: "index_resources_on_object_type_and_object_id", unique: true
  end

  create_table "warrants", force: :cascade do |t|
    t.string "object_type", null: false
    t.string "object_id", null: false
    t.string "relation", null: false
    t.string "subject_type", null: false
    t.string "subject_id", null: false
    t.string "subject_relation", default: ""
    t.text "policy", default: "", null: false
    t.string "policy_hash", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_warrants_on_deleted_at"
    t.index ["object_type", "object_id", "relation", "subject_type", "subject_id", "subject_relation", "policy_hash"], name: "index_warrants_on_unique_constraint", unique: true
  end

  create_table "wookies", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
  end
end
