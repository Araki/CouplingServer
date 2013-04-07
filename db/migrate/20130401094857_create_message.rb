class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :body
      t.integer :match_id,  :null => false
      t.string  :talk_key,  :null => false

      t.datetime :created_at,  :null => false
    end
    add_index :messages, :match_id
    add_index :messages, :talk_key
  end
end
