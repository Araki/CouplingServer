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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130409134155) do

  create_table "apn_devices", :force => true do |t|
    t.string   "token",              :default => "", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "last_registered_at"
  end

  add_index "apn_devices", ["token"], :name => "index_apn_devices_on_token", :unique => true

  create_table "apn_notifications", :force => true do |t|
    t.integer  "device_id",                        :null => false
    t.integer  "errors_nb",         :default => 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "apn_notifications", ["device_id"], :name => "index_apn_notifications_on_device_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "target_id",  :null => false
    t.datetime "created_at", :null => false
  end

  add_index "favorites", ["target_id"], :name => "index_favorites_on_target_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "images", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.boolean  "is_main",      :null => false
    t.integer  "order_number", :null => false
    t.datetime "created_at",   :null => false
  end

  add_index "images", ["user_id", "is_main"], :name => "index_images_on_user_id_and_is_main"
  add_index "images", ["user_id", "order_number"], :name => "index_images_on_user_id_and_order_number"

  create_table "items", :force => true do |t|
    t.string   "title",                         :null => false
    t.string   "pid",                           :null => false
    t.integer  "point",          :default => 0
    t.integer  "receipts_count", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "target_id",  :null => false
    t.datetime "created_at", :null => false
  end

  add_index "likes", ["target_id"], :name => "index_likes_on_target_id"
  add_index "likes", ["user_id", "target_id"], :name => "index_likes_on_user_id_and_target_id", :unique => true
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "matches", :force => true do |t|
    t.integer "user_id",                             :null => false
    t.integer "target_id",                           :null => false
    t.boolean "can_open_profile", :default => false
  end

  add_index "matches", ["user_id", "target_id"], :name => "index_matches_on_user_id_and_target_id", :unique => true
  add_index "matches", ["user_id"], :name => "index_matches_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "body"
    t.integer  "match_id",   :null => false
    t.string   "talk_key",   :null => false
    t.datetime "created_at", :null => false
  end

  add_index "messages", ["match_id"], :name => "index_messages_on_match_id"
  add_index "messages", ["talk_key"], :name => "index_messages_on_talk_key"

  create_table "mst_prefectures", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "receipts", :force => true do |t|
    t.string   "receipt_code", :null => false
    t.integer  "user_id",      :null => false
    t.integer  "item_id",      :null => false
    t.datetime "created_at",   :null => false
  end

  add_index "receipts", ["receipt_code"], :name => "index_receipts_on_receipt_code"
  add_index "receipts", ["user_id"], :name => "index_receipts_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "key",        :null => false
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
  end

  add_index "sessions", ["key"], :name => "index_sessions_on_key"

  create_table "users", :force => true do |t|
    t.integer  "facebook_id"
    t.string   "access_token"
    t.string   "profile_status"
    t.string   "email"
    t.string   "certification"
    t.string   "certification_status"
    t.string   "public_status"
    t.datetime "first_login_at"
    t.datetime "last_login_at"
    t.string   "invitation_code"
    t.string   "contract_type"
    t.integer  "like_point"
    t.integer  "point"
    t.string   "nickname"
    t.string   "introduction"
    t.integer  "gender"
    t.integer  "age"
    t.string   "country"
    t.string   "language"
    t.string   "address"
    t.string   "birthplace"
    t.string   "roommate"
    t.integer  "height"
    t.integer  "proportion"
    t.integer  "constellation"
    t.string   "blood_type"
    t.integer  "marital_history"
    t.integer  "marriage_time"
    t.integer  "want_child"
    t.integer  "relationship"
    t.integer  "have_child"
    t.integer  "smoking"
    t.integer  "alcohol"
    t.integer  "industry"
    t.integer  "job"
    t.string   "job_description"
    t.string   "workplace"
    t.integer  "income"
    t.string   "qualification"
    t.integer  "school"
    t.integer  "holiday"
    t.string   "sociability"
    t.string   "character"
    t.string   "speciality"
    t.string   "hobby"
    t.string   "dislike"
    t.string   "login_token"
    t.integer  "prefecture"
    t.string   "school_name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

end
