# coding: utf-8

FactoryGirl.define do
  factory :user do
    access_token      { Faker::Lorem.characters(10) }
    address           { Faker::Name.first_name }
    age               { 15 + rand(30) }
    alcohol           { rand(4) }
    birthplace        { rand(47) }
    blood_type        ['A', 'B', 'O', 'AB'].sample
    certification     '???'
    certification_status '???'
    character        nil
    country           'Japan'
    contract_type     '???'
    constellation     0
    dislike         'goki'
    email             {Faker::Internet.email}
    facebook_id       { Faker::Lorem.characters(10) }
    first_login_at    { rand(10).months.ago }
    gender            { rand(1) }
    have_child        0
    height            { rand(40) + 150 }
    hobby            nil
    holiday          { rand(4) }
    income           { rand(8) }
    introduction      { Faker::Lorem.sentence(40) }
    invitation_code   ''
    industry          0
    job               { rand(27) }
    job_description   ['会社員','医師','弁護士','公認会計士','経営者・役員','公務員','事務員','大手商社','外資金融','大手企業','大手外資','マスコミ・広告','クリエイター ','IT関連','パイロット','客室乗務員','芸能・モデル','アパレル・ショップ','アナウンサー ','イベントコンパニオン','受付',' 秘書','看護師','保育士','自由業','学生','その他'].sample
    language          'Japanese'
    last_login_at     { rand(20).days.ago }
    like_point        { rand(20) }
    login_token       { Faker::Lorem.characters(10) }
    marital_history   0
    marriage_time     0
    nickname          { Faker::Name.first_name }
    profile_status    '???'
    proportion        { rand(8) }
    point             { rand(300) }
    public_status     '???'
    prefecture       { rand(47) }
    qualification    '普通自動車免許'
    roommate          { rand(4) }
    relationship      0
    school_name      '辻調理師専門学校'
    smoking           { rand(3) }
    speciality       nil
    sociability      '???'
    want_child        0
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
