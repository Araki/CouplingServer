# coding: utf-8

FactoryGirl.define do
  factory  :profile, :class => Profile, :parent => :member do
    type    'Profile'
    user_id          1    
    birthday_on      { rand(40).years.ago }
    like_point        { rand(20) }

    factory :male_profile do
      gender 0
    end

    factory :female_profile do
      gender 1
    end
  end
end
