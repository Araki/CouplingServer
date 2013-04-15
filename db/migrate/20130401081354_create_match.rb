class CreateMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :user_id,                  :null => false
      t.integer :profile_id,               :null => false
      t.boolean :can_open_profile,         :default => false
    end
    add_index :matches, :user_id
    add_index :matches,[:user_id, :profile_id],:unique => true
  end
end
