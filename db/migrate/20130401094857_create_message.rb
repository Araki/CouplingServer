class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :body
      t.integer :match_id,  :null => false
      t.integer :user_id,   :null => false

      t.datetime :created_at,  :null => false
    end
    add_index :messages, :match_id
    add_index :messages, :user_id
  end
end
