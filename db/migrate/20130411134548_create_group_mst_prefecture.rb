class CreateGroupMstPrefecture < ActiveRecord::Migration
  def change
    create_table :group_mst_prefectures do |t|
      t.integer :group_id,      :null => false
      t.integer :mst_prefecture_id,      :null => false
    end
    add_index :group_mst_prefectures, :group_id
    add_index :group_mst_prefectures, :mst_prefecture_id
  end
end