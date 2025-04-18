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

ActiveRecord::Schema[7.1].define(version: 2024_10_10_092941) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "duo_participants", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.date "birth_date"
    t.integer "age"
    t.bigint "duo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "asset_id"
  end

  create_table "duos", force: :cascade do |t|
    t.string "name"
    t.string "responsable"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "discipline"
    t.string "level"
    t.string "title_of_music"
    t.string "composer"
    t.string "length_of_piece"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_duos_on_user_id"
  end

  create_table "group_forms", force: :cascade do |t|
    t.string "name"
    t.string "responsable"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "discipline"
    t.string "level"
    t.string "title_of_music"
    t.string "composer"
    t.string "length_of_piece"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_group_forms_on_user_id"
  end

  create_table "individual_forms", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "teacher_name"
    t.string "dance_school"
    t.string "teacher_phone"
    t.string "teacher_email"
    t.string "category"
    t.string "style"
    t.string "level"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_individual_forms_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.date "birth_date"
    t.integer "age"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trio_participants", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.date "birth_date"
    t.integer "age"
    t.bigint "trio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trios", force: :cascade do |t|
    t.string "name"
    t.string "responsable"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "discipline"
    t.string "level"
    t.string "title_of_music"
    t.string "composer"
    t.string "length_of_piece"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_trios_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 1
    t.string "name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "duos", "users"
  add_foreign_key "group_forms", "users"
  add_foreign_key "individual_forms", "users"
  add_foreign_key "trios", "users"
end
