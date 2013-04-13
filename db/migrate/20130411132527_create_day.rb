class CreateDay < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string  :name,         :null => false
    end
  end
end
