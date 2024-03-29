class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.integer :member_id,      :null => false
      t.boolean :is_main,      :null => false

      t.datetime :created_at,  :null => false
    end

    add_index :images, [:member_id, :is_main]
  end

  def down
    drop_table :images
  end
end
