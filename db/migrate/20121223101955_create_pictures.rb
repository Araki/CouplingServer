class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.boolean :is_main, :default => false

      t.timestamps
    end
  end
end
