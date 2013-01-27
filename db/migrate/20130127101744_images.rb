class Images < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.integer :user_id,      :null => false
      t.string  :type,         :null => false
      t.integer :order_number, :null => false
    end

    add_index :images, [:user_id, :type, :order_number], :unique => true
  end

  def down
    drop_table :images
  end
end
