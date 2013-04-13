class CreateMemberHobby < ActiveRecord::Migration
  def change
    create_table :member_hobbies do |t|
      t.integer :member_id,      :null => false
      t.integer :hobby_id,      :null => false
    end
    add_index :member_hobbies, :member_id
    add_index :member_hobbies, :hobby_id
  end
end
