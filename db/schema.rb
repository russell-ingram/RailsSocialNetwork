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

ActiveRecord::Schema.define(version: 20150731070407) do

  create_table "contents", force: :cascade do |t|
    t.string   "type_of_content",      default: "news"
    t.string   "name"
    t.string   "headline"
    t.text     "body_copy"
    t.string   "link_copy"
    t.string   "external_link"
    t.boolean  "active",               default: false
    t.integer  "layout_option"
    t.string   "layout_html_url"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "column_one_callout"
    t.string   "column_two_callout"
    t.string   "column_three_callout"
    t.text     "column_one_content"
    t.text     "column_two_content"
    t.text     "column_three_content"
    t.string   "image_url"
  end

  add_index "contents", ["type_of_content", "active"], name: "index_contents_on_type_of_content_and_active"

  create_table "employers", force: :cascade do |t|
    t.string  "name"
    t.integer "employer_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "state"
  end

  add_index "friendships", ["state"], name: "index_friendships_on_state"
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id"

  create_table "intentions", force: :cascade do |t|
    t.integer  "intention_id"
    t.integer  "search_id"
    t.string   "intention"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "sector_id"
    t.integer  "vendor_id"
    t.integer  "survey_id"
    t.integer  "user_id"
  end

  add_index "intentions", ["sector_id"], name: "index_intentions_on_sector_id"
  add_index "intentions", ["survey_id"], name: "index_intentions_on_survey_id"
  add_index "intentions", ["user_id"], name: "index_intentions_on_user_id"
  add_index "intentions", ["vendor_id"], name: "index_intentions_on_vendor_id"

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type"

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"

  create_table "requests", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "linked_in"
    t.string   "job_title"
    t.string   "company"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "search_id"
    t.string   "name"
    t.string   "industry"
    t.string   "enterprise"
    t.string   "organization_type"
    t.string   "region"
    t.string   "country"
    t.string   "job_title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "results"
    t.integer  "peers"
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "survey_id"
    t.datetime "date_taken"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "employer"
    t.string   "industry"
    t.string   "profile_pic_url"
    t.boolean  "admin",                  default: false
    t.boolean  "privacy_profile",        default: true
    t.boolean  "notifications",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "position"
    t.string   "footprint"
    t.string   "linked_in_url"
    t.string   "enterprise_size"
    t.string   "region"
    t.string   "country"
    t.text     "emp_summary"
    t.text     "summary"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vendors", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "works", force: :cascade do |t|
    t.string   "company"
    t.string   "industry"
    t.string   "enterprise_size"
    t.string   "region"
    t.string   "country"
    t.string   "start_date"
    t.string   "end_date"
    t.text     "summary"
    t.boolean  "current"
    t.boolean  "public"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "job_title"
    t.string   "footprint"
    t.string   "uid"
  end

end
