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

ActiveRecord::Schema.define(:version => 20130412073152) do

  create_table "characters", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "days", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "target_id",  :null => false
    t.datetime "created_at", :null => false
  end

  add_index "favorites", ["target_id"], :name => "index_favorites_on_target_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "group_days", :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "day_id",   :null => false
  end

  add_index "group_days", ["day_id"], :name => "index_group_days_on_day_id"
  add_index "group_days", ["group_id"], :name => "index_group_days_on_group_id"

  create_table "group_group_images", :force => true do |t|
    t.integer "group_id",       :null => false
    t.integer "group_image_id", :null => false
  end

  add_index "group_group_images", ["group_id"], :name => "index_group_group_images_on_group_id"
  add_index "group_group_images", ["group_image_id"], :name => "index_group_group_images_on_group_image_id"

  create_table "group_images", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "group_mst_prefectures", :force => true do |t|
    t.integer "group_id",          :null => false
    t.integer "mst_prefecture_id", :null => false
  end

  add_index "group_mst_prefectures", ["group_id"], :name => "index_group_mst_prefectures_on_group_id"
  add_index "group_mst_prefectures", ["mst_prefecture_id"], :name => "index_group_mst_prefectures_on_mst_prefecture_id"

  create_table "groups", :force => true do |t|
    t.integer "status",           :default => 0
    t.integer "gender",           :default => 0
    t.integer "user_id",                         :null => false
    t.integer "max_age",                         :null => false
    t.integer "min_age",                         :null => false
    t.integer "head_count",                      :null => false
    t.string  "relationship",                    :null => false
    t.string  "request"
    t.time    "opening_hour"
    t.integer "target_age_range"
    t.string  "area"
  end

  add_index "groups", ["gender"], :name => "index_groups_on_gender"

  create_table "hobbies", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "member_id",  :null => false
    t.boolean  "is_main",    :null => false
    t.datetime "created_at", :null => false
  end

  add_index "images", ["member_id", "is_main"], :name => "index_images_on_member_id_and_is_main"

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

  create_table "member_characters", :force => true do |t|
    t.integer "member_id",    :null => false
    t.integer "character_id", :null => false
  end

  add_index "member_characters", ["character_id"], :name => "index_member_characters_on_character_id"
  add_index "member_characters", ["member_id"], :name => "index_member_characters_on_member_id"

  create_table "member_hobbies", :force => true do |t|
    t.integer "member_id", :null => false
    t.integer "hobby_id",  :null => false
  end

  add_index "member_hobbies", ["hobby_id"], :name => "index_member_hobbies_on_hobby_id"
  add_index "member_hobbies", ["member_id"], :name => "index_member_hobbies_on_member_id"

  create_table "member_specialities", :force => true do |t|
    t.integer "member_id",     :null => false
    t.integer "speciality_id", :null => false
  end

  add_index "member_specialities", ["member_id"], :name => "index_member_specialities_on_member_id"
  add_index "member_specialities", ["speciality_id"], :name => "index_member_specialities_on_speciality_id"

  create_table "members", :force => true do |t|
    t.string   "type",                           :null => false
    t.integer  "status",          :default => 0
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "nickname"
    t.string   "introduction"
    t.integer  "gender"
    t.integer  "age"
    t.date     "birthday_on"
    t.integer  "birthplace"
    t.string   "roommate"
    t.integer  "height"
    t.integer  "proportion"
    t.string   "blood_type"
    t.integer  "marital_history"
    t.integer  "marriage_time"
    t.integer  "smoking"
    t.integer  "alcohol"
    t.integer  "industry"
    t.integer  "job"
    t.string   "job_description"
    t.string   "workplace"
    t.integer  "income"
    t.integer  "school"
    t.integer  "holiday"
    t.integer  "sociability"
    t.string   "dislike"
    t.integer  "prefecture"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "members", ["gender"], :name => "index_members_on_gender"
  add_index "members", ["group_id"], :name => "index_members_on_group_id"
  add_index "members", ["user_id"], :name => "index_members_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "body"
    t.integer  "match_id",   :null => false
    t.integer  "user_id",    :null => false
    t.integer  "target_id",  :null => false
    t.datetime "created_at", :null => false
  end

  add_index "messages", ["target_id"], :name => "index_messages_on_target_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "mst_prefectures", :force => true do |t|
    t.string "name"
  end

  create_table "receipts", :force => true do |t|
    t.string   "receipt_code", :null => false
    t.integer  "user_id",      :null => false
    t.integer  "item_id",      :null => false
    t.datetime "created_at",   :null => false
  end

  add_index "receipts", ["receipt_code"], :name => "index_receipts_on_receipt_code"
  add_index "receipts", ["user_id"], :name => "index_receipts_on_user_id"

  create_table "relations", :force => true do |t|
    t.string   "type",                                :null => false
    t.integer  "user_id",                             :null => false
    t.integer  "target_id",                           :null => false
    t.boolean  "can_open_profile", :default => false
    t.datetime "last_read_at"
    t.datetime "created_at",                          :null => false
  end

  add_index "relations", ["target_id"], :name => "index_relations_on_target_id"
  add_index "relations", ["user_id", "target_id"], :name => "index_relations_on_user_id_and_target_id", :unique => true
  add_index "relations", ["user_id"], :name => "index_relations_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "key",        :null => false
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
  end

  add_index "sessions", ["key"], :name => "index_sessions_on_key"

  create_table "specialities", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "status"
    t.integer  "facebook_id",     :limit => 8
    t.string   "email"
    t.string   "access_token"
    t.string   "device_token"
    t.string   "invitation_code"
    t.string   "contract_type"
    t.integer  "point",                        :default => 0
    t.integer  "like_point",                   :default => 0
    t.datetime "last_login_at"
    t.datetime "last_verify_at"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["like_point"], :name => "index_users_on_like_point"

end
