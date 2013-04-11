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

ActiveRecord::Schema.define(:version => 20130411054620) do

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

  create_table "characters", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "target_id",  :null => false
    t.datetime "created_at", :null => false
  end

  add_index "favorites", ["target_id"], :name => "index_favorites_on_target_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "groups", :force => true do |t|
    t.integer "max_age",          :null => false
    t.integer "min_age",          :null => false
    t.integer "head_count",       :null => false
    t.string  "relationship",     :null => false
    t.string  "request"
    t.time    "opening_hour"
    t.integer "target_age_range"
    t.string  "area"
  end

  create_table "hobbies", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.boolean  "is_main",    :null => false
    t.datetime "created_at", :null => false
  end

  add_index "images", ["user_id", "is_main"], :name => "index_images_on_user_id_and_is_main"

  create_table "infos", :force => true do |t|
    t.integer  "target_id",  :default => -1, :null => false
    t.string   "body",                       :null => false
    t.datetime "created_at",                 :null => false
  end

  add_index "infos", ["target_id"], :name => "index_infos_on_target_id"

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

  create_table "specialities", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "user_characters", :force => true do |t|
    t.integer "user_id",      :null => false
    t.integer "character_id", :null => false
  end

  add_index "user_characters", ["character_id"], :name => "index_user_characters_on_character_id"
  add_index "user_characters", ["user_id"], :name => "index_user_characters_on_user_id"

  create_table "user_hobbies", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "hobby_id", :null => false
  end

  add_index "user_hobbies", ["hobby_id"], :name => "index_user_hobbies_on_hobby_id"
  add_index "user_hobbies", ["user_id"], :name => "index_user_hobbies_on_user_id"

  create_table "user_specialities", :force => true do |t|
    t.integer "user_id",       :null => false
    t.integer "speciality_id", :null => false
  end

  add_index "user_specialities", ["speciality_id"], :name => "index_user_specialities_on_speciality_id"
  add_index "user_specialities", ["user_id"], :name => "index_user_specialities_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "group_id"
    t.integer  "facebook_id"
    t.string   "access_token"
    t.string   "status"
    t.string   "email"
    t.string   "public_status"
    t.datetime "last_login_at"
    t.string   "invitation_code"
    t.string   "contract_type"
    t.integer  "like_point"
    t.integer  "point",           :default => 0
    t.string   "nickname"
    t.string   "introduction"
    t.integer  "gender"
    t.integer  "age"
    t.integer  "birthplace"
    t.string   "roommate"
    t.integer  "height"
    t.integer  "proportion"
    t.string   "blood_type"
    t.integer  "marital_history"
    t.integer  "marriage_time"
    t.integer  "relationship"
    t.integer  "smoking"
    t.integer  "alcohol"
    t.integer  "industry"
    t.integer  "job"
    t.string   "job_description"
    t.string   "workplace"
    t.integer  "income"
    t.integer  "school"
    t.integer  "holiday"
    t.string   "sociability"
    t.string   "dislike"
    t.integer  "prefecture"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "users", ["access_token"], :name => "index_users_on_access_token"
  add_index "users", ["group_id"], :name => "index_users_on_group_id"

end
