# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_18_214751) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "client_contacts", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "eitc_estimates", force: :cascade do |t|
    t.string "status"
    t.integer "children"
    t.integer "income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visitor_id"
    t.string "filed_recently", default: "unset"
    t.string "claimed_eitc", default: "unset"
  end

  create_table "household_members", force: :cascade do |t|
    t.bigint "vita_client_id"
    t.string "first_name"
    t.string "last_name"
    t.datetime "birthdate"
    t.string "full_time_student"
    t.string "non_citizen"
    t.string "disabled"
    t.string "legally_blind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "relation"
    t.index ["vita_client_id"], name: "index_household_members_on_vita_client_id"
  end

  create_table "reminder_contacts", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visitor_id"
  end

  create_table "research_contacts", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "visitor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "unique_token"
    t.datetime "followed_interview_link"
    t.string "appointment_url"
    t.string "source"
    t.index ["unique_token"], name: "index_research_contacts_on_unique_token", unique: true
  end

  create_table "signing_requests", force: :cascade do |t|
    t.bigint "vita_client_id"
    t.string "federal_signature"
    t.string "federal_signature_spouse"
    t.string "state_signature"
    t.string "state_signature_spouse"
    t.string "signature_ip"
    t.datetime "signed_at"
    t.string "email"
    t.string "unique_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["vita_client_id"], name: "index_signing_requests_on_vita_client_id"
  end

  create_table "vita_clients", force: :cascade do |t|
    t.string "phone_number"
    t.string "email"
    t.string "has_spouse"
    t.string "why_cant_file_with_spouse"
    t.string "anyone_self_employed"
    t.string "anything_else"
    t.string "signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visitor_id"
    t.string "street_address"
    t.string "city"
    t.string "zip"
    t.string "sms_enabled"
    t.string "has_dependents"
    t.string "state"
    t.string "source"
    t.datetime "signed_at"
    t.string "signature_ip"
    t.string "spouse_signature"
    t.string "encrypted_last_four_ssn"
    t.string "encrypted_last_four_ssn_iv"
    t.string "encrypted_last_four_ssn_spouse"
    t.string "encrypted_last_four_ssn_spouse_iv"
    t.string "referrer"
    t.boolean "ready_to_submit_docs"
    t.text "tax_years", default: [], array: true
    t.text "years_already_filed", default: [], array: true
    t.text "already_filed_needs"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "household_members", "vita_clients"
  add_foreign_key "signing_requests", "vita_clients"
end
