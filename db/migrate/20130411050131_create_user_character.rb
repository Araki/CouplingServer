class CreateUserCharacter < ActiveRecord::Migration
  def change
    create_table :user_characters do |t|
      t.integer :user_id,      :null => false
      t.integer :character_id,      :null => false
    end
    add_index :user_characters, :user_id
    add_index :user_characters, :character_id
  end
end