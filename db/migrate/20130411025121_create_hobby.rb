class CreateHobby < ActiveRecord::Migration
  def change
    create_table :hobbies do |t|
      t.string  :name,         :null => false
    end
  end
end
