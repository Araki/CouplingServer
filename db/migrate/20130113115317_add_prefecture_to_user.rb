class AddPrefectureToUser < ActiveRecord::Migration
  def change
    add_column :users, :prefecture, :int
  end
end
