# -*r coding: utf-8 -*-

class CreateItem < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string  :title,          :null => false
      t.string  :pid,            :null => false
      t.integer :point,          :default => 0
      t.integer :receipts_count, :default => 0

      t.timestamps
    end
    # 列が少ないのでindexはいらない。
  end
end
