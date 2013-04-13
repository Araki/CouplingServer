# coding: utf-8

FactoryGirl.define do
  factory  :profile, :class => Profile, :parent => :member do
    type    'Profile'
    user_id          1    
  end
end
