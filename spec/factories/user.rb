# coding: utf-8

FactoryGirl.define do
  factory :user do
    gender            0
    access_token      { Faker::Lorem.characters(100) }
    contract_type    nil
    device_token      { Faker::Lorem.characters(30) }
    email             {Faker::Internet.email}
    facebook_id       { Faker::Base.numerify('##########').to_i }
    invitation_code   ''
    last_login_at     { rand(20).days.ago }
    like_point        { rand(20) }
    status            '???'
    point             { rand(300) }
    public_status     '???'

    factory :boys do
      gender 0
    end

    factory :girls do
      gender 1
    end
  end

  # factory :invalid_user, parent: :user do
  #   nickname nil
  # end  
end
