class CreateReceipt < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string  :receipt_code, :null => false
      t.integer :user_id,      :null => false
      t.integer :item_id,      :null => false

      t.datetime :created_at,  :null => false
    end
    add_index :receipts, :receipt_code
    add_index :receipts, :user_id
  end
end
