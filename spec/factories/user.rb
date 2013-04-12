# coding: utf-8

FactoryGirl.define do
  factory :user do
    access_token      { Faker::Lorem.characters(100) }
    age               { 15 + rand(30) }
    alcohol           { rand(4) }
    birthplace        { rand(47) + 1 }
    blood_type        ['A', 'B', 'O', 'AB'].sample
    contract_type    nil
    device_token      { Faker::Lorem.characters(30) }
    dislike         'goki'
    email             {Faker::Internet.email}
    facebook_id       { Faker::Base.numerify('##########').to_i }
    gender            { rand(1) }
    height            { rand(40) + 150 }
    holiday          { rand(4) }
    income           { rand(8) }
    introduction      { Faker::Lorem.sentence(40) }
    invitation_code   ''
    industry          0
    job               { rand(27) }
    job_description   ['会社員','医師','弁護士','公認会計士','経営者・役員','公務員','事務員','大手商社','外資金融','大手企業','大手外資','マスコミ・広告','クリエイター ','IT関連','パイロット','客室乗務員','芸能・モデル','アパレル・ショップ','アナウンサー ','イベントコンパニオン','受付',' 秘書','看護師','保育士','自由業','学生','その他'].sample
    last_login_at     { rand(20).days.ago }
    like_point        { rand(20) }
    marital_history   0
    marriage_time     0
    nickname          { Faker::Name.first_name }
    status            '???'
    proportion        { rand(8) }
    point             { rand(300) }
    public_status     '???'
    prefecture       { rand(47) + 1 }
    roommate          { rand(4) }
    smoking           { rand(3) }
    sociability      '???'
    workplace        '渋谷区'

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
