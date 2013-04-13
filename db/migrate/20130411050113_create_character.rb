class CreateCharacter < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string  :name,         :null => false
    end
  end
end
