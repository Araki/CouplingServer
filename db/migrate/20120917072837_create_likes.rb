class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id,   :null => false
      t.integer :target_id, :null => false

      t.datetime :created_at,  :null => false
    end
    add_index :likes, :user_id
    add_index :likes, :target_id
    add_index :likes,[:user_id,:target_id],:unique => true
  end
end
