# coding: utf-8

FactoryGirl.define do
  factory  :friend, :class => Friend, :parent => :member do
    type    'Friend'
    group_id          1
  end
end
