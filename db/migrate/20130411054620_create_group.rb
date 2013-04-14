class CreateGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|      
      t.integer :status,            :default => 0
      t.integer :gender,            :default => 0
      t.integer :user_id,           :null => false
      t.integer :max_age,           :null => false
      t.integer :min_age,           :null => false
      t.integer :head_count,        :null => false
      t.string  :relationship,      :null => false
      t.string  :request
      t.time    :opening_hour
      t.integer :target_age_range
      t.string  :area
    end
  end
end
