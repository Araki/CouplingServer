class CreateUserHobby < ActiveRecord::Migration
  def change
    create_table :user_hobbies do |t|
      t.integer :user_id,      :null => false
      t.integer :hobby_id,      :null => false
    end
    add_index :user_hobbies, :user_id
    add_index :user_hobbies, :hobby_id
  end
end
