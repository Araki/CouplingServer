class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :facebook_id
      t.string :access_token
      t.string :main_picture
      t.string :sub_picture1
      t.string :sub_picture2
      t.string :sub_picture3
      t.string :sub_picture4
      t.string :profile_status
      t.string :email
      t.string :certification
      t.string :certification_status
      t.string :public_status
      t.datetime :first_login_at
      t.datetime :last_login_at
      t.string :invitation_code
      t.string :contract_type
      t.integer :like_pointeger
      t.integer :pointeger
      t.string :nickname
      t.string :integerroduction
      t.integer :gender
      t.integer :age
      t.string :country
      t.string :language
      t.string :address
      t.string :birthplace
      t.string :roommate
      t.integer :height
      t.integer :proportion
      t.integer :constellation
      t.string :blood_type
      t.integer :marital_history
      t.integer :marriage_time
      t.integer :want_child
      t.integer :relationship
      t.integer :have_child
      t.integer :smoking
      t.integer :alcohol
      t.integer :industry
      t.integer :job
      t.string :job_description
      t.string :workplace
      t.integer :income
      t.string :qualification
      t.integer :school
      t.integer :holiday
      t.string :sociability
      t.string :character
      t.string :speciality
      t.string :hobby
      t.string :dislike

      t.timestamps
    end
  end
end