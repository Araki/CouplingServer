class CreateMemberSpeciality < ActiveRecord::Migration
  def change
    create_table :member_specialities do |t|
      t.integer :member_id,      :null => false
      t.integer :speciality_id,      :null => false
    end
    add_index :member_specialities, :member_id
    add_index :member_specialities, :speciality_id
  end
end