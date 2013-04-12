class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer  "gender"
      t.integer  "group_id"
      t.integer  "facebook_id", :limit=>8
      t.string   "email"
      t.string   "access_token"
      t.string   "device_token"
      t.string   "status"
      t.string   "public_status"
      t.datetime "last_login_at"
      t.string   "invitation_code"
      t.string   "contract_type"
      t.integer  "like_point"
      t.integer  "point",          :default => 0

      t.timestamps
    end
    add_index :users, :group_id
    add_index :users, :access_token
  end
end
