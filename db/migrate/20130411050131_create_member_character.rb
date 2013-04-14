class CreateMemberCharacter < ActiveRecord::Migration
  def change
    create_table :member_characters do |t|
      t.integer :member_id,      :null => false
      t.integer :character_id,      :null => false
    end
    add_index :member_characters, :member_id
    add_index :member_characters, :character_id
  end
end