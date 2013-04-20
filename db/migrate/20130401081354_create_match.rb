class CreateMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :user_id,                  :null => false
      t.integer :profile_id,               :null => false
      t.boolean :can_open_profile,         :default => false
      t.integer :unread_count,             :default => 0
      t.datetime :last_read_at
    end
    add_index :matches, :user_id
    add_index :matches,[:user_id, :profile_id],:unique => true
  end
end
