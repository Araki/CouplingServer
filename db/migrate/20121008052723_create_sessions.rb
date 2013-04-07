class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :key,   :null => false
      t.string :value, :null => false

      t.datetime :created_at,  :null => false
    end
    add_index :sessions, :key
  end
end
