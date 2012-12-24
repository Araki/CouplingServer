class RemovePictureFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :main_picture
    remove_column :users, :sub_picture1
    remove_column :users, :sub_picture2
    remove_column :users, :sub_picture3
    remove_column :users, :sub_picture4
  end

  def down
    add_column :users, :sub_picture4, :string
    add_column :users, :sub_picture3, :string
    add_column :users, :sub_picture2, :string
    add_column :users, :sub_picture1, :string
    add_column :users, :main_picture, :string
  end
end
