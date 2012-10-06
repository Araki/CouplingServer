class CreateMySessions < ActiveRecord::Migration
  def change
    create_table :my_sessions do |t|
      t.string :session_id
      t.string :body

      t.timestamps
    end
  end
end
