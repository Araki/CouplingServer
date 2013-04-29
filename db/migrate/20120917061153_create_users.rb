class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   "status"
      t.integer  "facebook_id", :limit=>8
      t.string   "email"
      t.string   "access_token"
      t.string   "device_token"
      t.string   "invitation_code"
      t.string   "contract_type"
      t.integer  "point",          :default => 0
      t.integer  :like_point,     :default => 0
      t.datetime "last_login_at"
      t.datetime "last_verify_at"

      t.timestamps
    end
    add_index :users, :facebook_id
    add_index :users, :like_point
  end
end
