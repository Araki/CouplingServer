class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string   :type,             :null => false
      t.integer  :user_id,          :null => false
      t.integer  :target_id,        :null => false
      t.boolean  :can_open_profile, :default => false
      t.datetime :last_read_at

      t.datetime :created_at,       :null => false
    end
    add_index :relations, :user_id
    add_index :relations, :target_id
    add_index :relations,[:user_id,:target_id],:unique => true
  end
end
