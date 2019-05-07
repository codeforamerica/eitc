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

ActiveRecord::Schema.define(version: 2019_05_07_005128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "eitc_estimate_id"
    t.index ["eitc_estimate_id"], name: "index_research_contacts_on_eitc_estimate_id"
    t.index ["unique_token"], name: "index_research_contacts_on_unique_token", unique: true
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
  end

  add_foreign_key "household_members", "vita_clients"
  add_foreign_key "research_contacts", "eitc_estimates"
end
