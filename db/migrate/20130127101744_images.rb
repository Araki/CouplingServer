class Images < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.integer :user_id,      :null => false
      t.boolean :is_main,      :null => false
      t.integer :order_number, :null => false

      t.datetime :created_at,  :null => false
    end

    add_index :images, [:user_id, :is_main]
    add_index :images, [:user_id, :order_number]
  end

  def down
    drop_table :images
  end
end
