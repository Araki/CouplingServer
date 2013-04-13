class CreateGroupImage < ActiveRecord::Migration
  def change
    create_table :group_images do |t|
      t.string  :name,         :null => false
    end
  end
end
