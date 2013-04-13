class CreateMstPrefectures < ActiveRecord::Migration
  def change
    create_table :mst_prefectures do |t|
      t.string :name
    end
  end
end
