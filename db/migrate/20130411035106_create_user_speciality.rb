class CreateUserSpeciality < ActiveRecord::Migration
  def change
    create_table :user_specialities do |t|
      t.integer :user_id,      :null => false
      t.integer :speciality_id,      :null => false
    end
    add_index :user_specialities, :user_id
    add_index :user_specialities, :speciality_id
  end
end