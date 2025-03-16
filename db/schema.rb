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

ActiveRecord::Schema[8.0].define(version: 2025_03_15_000006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authorization_cache_entries", force: :cascade do |t|
    t.string "namespace", null: false
    t.string "object_id", null: false
    t.string "relation", null: false
    t.string "subject_type", null: false
    t.string "subject_id", null: false
    t.string "subject_relation"
    t.boolean "result", null: false
    t.jsonb "caveat_expression"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "idx_cache_expiration"
    t.index ["namespace", "object_id", "relation", "subject_type", "subject_id", "subject_relation"], name: "idx_check_cache_lookup"
  end

  create_table "authorization_caveats", force: :cascade do |t|
    t.string "name", null: false
    t.text "definition", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authorization_caveats_on_name", unique: true
  end

  create_table "authorization_namespaces", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authorization_namespaces_on_name", unique: true
  end

  create_table "authorization_relations", force: :cascade do |t|
    t.bigint "authorization_namespace_id", null: false
    t.string "name", null: false
    t.string "type_name", default: "relation", null: false
    t.jsonb "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorization_namespace_id", "name"], name: "idx_namespace_relation", unique: true
    t.index ["authorization_namespace_id"], name: "index_authorization_relations_on_authorization_namespace_id"
  end

  create_table "authorization_tuples", force: :cascade do |t|
    t.string "namespace", null: false
    t.string "object_id", null: false
    t.string "relation", null: false
    t.string "subject_type", null: false
    t.string "subject_id", null: false
    t.string "subject_relation"
    t.jsonb "caveat_context", default: {}
    t.string "caveat_name"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "idx_expiration", where: "(expires_at IS NOT NULL)"
    t.index ["namespace", "object_id", "relation", "subject_type", "subject_id"], name: "idx_permission_check"
    t.index ["namespace", "object_id", "relation"], name: "idx_resource_lookup"
    t.index ["subject_type", "subject_id"], name: "idx_subject_lookup"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "folder_id"
    t.boolean "comments_enabled", default: true
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_documents_on_folder_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_folders_on_parent_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "team_id"
    t.decimal "budget", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_projects_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "organization_id"
    t.boolean "members_can_assign_tasks", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "authorization_relations", "authorization_namespaces"
  add_foreign_key "documents", "folders"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "projects", "teams"
  add_foreign_key "teams", "organizations"
end
