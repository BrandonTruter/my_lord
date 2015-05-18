# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150517151451) do

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.string   "middle_name",       limit: 255
    t.boolean  "married",           limit: 1,   default: false
    t.string   "language",          limit: 255
    t.string   "race",              limit: 255
    t.string   "religion",          limit: 255
    t.string   "phone",             limit: 255
    t.string   "fax",               limit: 255
    t.string   "qualifications",    limit: 255
    t.string   "hobbies",           limit: 255
    t.string   "interests",         limit: 255
    t.string   "company",           limit: 255
    t.string   "position",          limit: 255
    t.string   "occupation",        limit: 255
    t.string   "gender",            limit: 255
    t.datetime "date_of_birth"
    t.integer  "family_size",       limit: 4
    t.float    "net_salary",        limit: 24
    t.string   "street_number",     limit: 255
    t.string   "street_name",       limit: 255
    t.string   "suburb",            limit: 255
    t.string   "city",              limit: 255
    t.string   "province",          limit: 255
    t.string   "postal_code",       limit: 255
    t.string   "spouse_first_name", limit: 255
    t.string   "spouse_last_name",  limit: 255
    t.string   "spouse_occupation", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scriptures", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "reference",  limit: 255
    t.string   "verse",      limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255, default: "",             null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "id_number",              limit: 255
    t.string   "mobile",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles",                  limit: 255, default: "--- ['user']"
    t.boolean  "monthly_scripture",      limit: 1
    t.boolean  "completed_registration", limit: 1,   default: false
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
