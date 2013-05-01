class CreateMember < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string   :type,      :null => false
      t.integer  :status,    :default => 0
      t.integer  :user_id
      t.integer  :group_id
      t.string   :nickname
      t.string   :introduction
      t.integer  :gender
      t.integer  :age
      t.date     :birthday_on
      t.integer  :birthplace
      t.string   :roommate
      t.integer  :height
      t.integer  :proportion
      t.string   :blood_type
      t.integer  :marital_history
      t.integer  :marriage_time
      t.integer  :smoking
      t.integer  :alcohol
      t.integer  :industry
      t.integer  :job
      t.string   :job_description
      t.string   :workplace
      t.integer  :income
      t.integer  :school
      t.integer  :holiday
      t.integer  :sociability
      t.string   :dislike
      t.integer  :prefecture

      t.timestamps
    end
    add_index :members, :gender
    add_index :members, :user_id
    add_index :members, :group_id
  end
end
