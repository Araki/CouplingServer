class ModifyColumn < ActiveRecord::Migration
  def up
    rename_column :users, :like_pointeger, :like_point
    rename_column :users, :pointeger, :point
    rename_column :users, :integerroduction, :introduction
  end

  def down
  end
end
