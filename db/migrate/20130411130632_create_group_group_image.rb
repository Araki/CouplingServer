class CreateGroupGroupImage < ActiveRecord::Migration
  def change
    create_table :group_group_images do |t|
      t.integer :group_id,      :null => false
      t.integer :group_image_id,      :null => false
    end
    add_index :group_group_images, :group_id
    add_index :group_group_images, :group_image_id
  end
end