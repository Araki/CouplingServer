class CreateSpeciality < ActiveRecord::Migration
  def change
    create_table :specialities do |t|
      t.string  :name,         :null => false
    end
  end
end
