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

ActiveRecord::Schema.define(version: 20150401152005) do

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 4000, default: "",   null: false
    t.string   "encrypted_password",     limit: 4000, default: "",   null: false
    t.string   "reset_password_token",   limit: 4000
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,    default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 4000
    t.string   "last_sign_in_ip",        limit: 4000
    t.string   "first_name",             limit: 4000
    t.string   "last_name",              limit: 4000
    t.string   "employer",               limit: 4000
    t.string   "industry",               limit: 4000
    t.string   "location",               limit: 4000
    t.boolean  "privacy_profile",                     default: true
    t.boolean  "notifications",                       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",               limit: 4000
    t.string   "uid",                    limit: 4000
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
