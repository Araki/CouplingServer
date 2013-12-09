# coding: utf-8

FactoryGirl.define do
  factory :member do
    type              'Profile'
    status            1
    age               { 15 + rand(30) }
    blood_type        { ['A', 'B', 'O', 'AB'].sample }
    gender            { rand(1) }
    holiday           { rand(4) }
    income            { rand(8) }
    introduction      { Faker::Lorem.sentence(30) }
    industry          0
    job               { rand(27) }
    nickname          { Faker::Name.first_name }
    prefecture        { rand(47) + 1 }
  end
end
