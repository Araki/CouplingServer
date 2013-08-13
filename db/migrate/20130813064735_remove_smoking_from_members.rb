class RemoveSmokingFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :birthplace
    remove_column :members, :roommate
    remove_column :members, :height
    remove_column :members, :marital_history
    remove_column :members, :marriage_time
    remove_column :members, :smoking
    remove_column :members, :alcohol
    remove_column :members, :job_description
    remove_column :members, :workplace
    remove_column :members, :sociability
    remove_column :members, :dislike
  end

  def down
    add_column :members, :birthplace, :integer
    add_column :members, :roommate, :string
    add_column :members, :height, :integer
    add_column :members, :marital_history, :integer
    add_column :members, :marriage_time,:integer
    add_column :members, :smoking, :integer
    add_column :members, :alcohol, :integer
    add_column :members, :job_description, :string
    add_column :members, :workplace, :string
    add_column :members, :sociability, :integer
    add_column :members, :dislike, :string
  end
end
