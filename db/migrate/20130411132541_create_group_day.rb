class CreateGroupDay < ActiveRecord::Migration
  def change
    create_table :group_days do |t|
      t.integer :group_id,      :null => false
      t.integer :day_id,      :null => false
    end
    add_index :group_days, :group_id
    add_index :group_days, :day_id
  end
end