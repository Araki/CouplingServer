class CreateMstPrefectures < ActiveRecord::Migration
  def change
    create_table :mst_prefectures do |t|
      t.string :name

      t.timestamps
    end
  end
end
