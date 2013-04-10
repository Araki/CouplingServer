class CreateInfo < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.integer :target_id,    :null => false, :default => -1
      t.string  :body,         :null => false

      t.datetime :created_at,  :null => false
    end
    add_index :infos, :target_id
  end
end
