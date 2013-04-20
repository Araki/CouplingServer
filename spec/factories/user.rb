# coding: utf-8

FactoryGirl.define do
  factory :user do
    access_token      { Faker::Lorem.characters(100) }
    contract_type    nil
    device_token      { Faker::Lorem.characters(30) }
    email             {Faker::Internet.email}
    facebook_id       { Faker::Base.numerify('##########').to_i }
    invitation_code   ''
    last_login_at     { rand(20).days.ago }
    last_verify_at    { rand(20).days.ago }
    status            1
    point             { rand(300) }
  end
end
