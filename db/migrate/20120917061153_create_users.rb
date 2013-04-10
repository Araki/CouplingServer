class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer  "facebook_id"
      t.string   "access_token"
      t.string   "status"
      t.string   "email"
      t.string   "public_status"
      t.datetime "last_login_at"
      t.string   "invitation_code"
      t.string   "contract_type"
      t.integer  "like_point"
      t.integer  "point",          :default => 0
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

      t.timestamps
    end
  end
end
