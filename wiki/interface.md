# contents
* POST sessions#create
* GET  sessions#verify
* POST sessions#destroy
* GET  account#show_profile
* POST account#update_profile
* POST account#destroy
* GET  users#list
* GET  users#show
* GET  groups#show
* GET  groups#list
* POST groups#create
* POST groups#update
* POST friends#create
* POST friends#update
* POST friends#destroy
* GET  images#list
* POST images#create
* POST images#destroy
* POST images#set_main
* GET  likes#list
* GET  matches#list
* POST likes#create
* GET  favorites#list
* POST favorites#create
* POST favorites#destroy
* GET  messages#list
* POST messages#create
* GET  items#list
* POST points#add
* POST points#consume
* GET  infos#list
* GET  receipts#list
* POST receipts#validate


## POST sessions#create

初期登録時に叩くAPI。Facebookのアクセストークンを投げると、セッションIDを生成。

### Parameters

param | require | description
------|---------|------
fb_token | o | Facebookのアクセストークン
device_token | o | デバイストークン

### Example Request

    http://pairful.com/api/sessions/create

### Example Response

    {単独ユーザーのレスポンス例(後述)}

## GET sessions#verify

session_idが有効な場合、trueを、無効な場合、falseを返す。

### Parameters

param | require | description
------|---------|------
session_id| o |セッションID

### Example Request

    http://pairful.com/api/sessions/verify?session_id=abc
### Example Response

    {単独ユーザーのレスポンス例(後述)}

## POST sessions#destroy

セッションIDを無効にする。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/sessions/destroy

### Example Response

    {"status":"ok"}

## GET account#show_profile

セッションのユーザのプロフィールを返す。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/account/show_profile?session_id=abc

### Example Response

    {プロフィール/Friendの例(後述)}

## POST user/account#destroy

退会する。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/account/destroy

### Example Response
 
    {"status":"ok"}

## POST account#update_profile

自分のプロフィールを更新する。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
user[xxx]| o | 更新するユーザーのパラメータ

    {nickname: 'maru', height: 200} # => x
    {user[nickname]: 'maru', user[height]: 200} # => o Railsによるバリデーションのため

### Example Request

    http://pairful.com/api/account/update_profile

### Example Response
 
     {プロフィール/Friendの例(後述)}

## GET  users#list

異性のリストを最新登録順に返す。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
filter_key| - | フィルターをかける条件のキーを指定する liked(未実装)
filter_value| - | フィルターをかける条件の値を指定する true(未実装)
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件  

### 仕様の変更を検討（天野：2012年10月20日）
* https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
* #{max_id} #{since_id}を指定してリストの読み込み範囲を指定するようにする
* #{start_index}と#{count}ではリアルタイムな更新があるとどこから読み込めばいいかわからなくなる。

### Example Request

    http://pairful.com/api/users/list?session_id=abc  

### Example Response

    {後述:ユーザーリストのレスポンス例}

## GET users#show

特定のユーザーのプロフィールの詳細を取得

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/users/(:id)/show?session_id=abc 

### Example Response

    {単独ユーザーのレスポンス例(後述)}

## GET groups#show

自分が所有するグループを取得

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/groups/show?session_id=abc 

### Example Response

    {単独グループのレスポンス例(後述)}

## GET groups#list

グループのリストを取得

param | require | description
------|---------|------
session_id| o | セッションID
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件  

### Example Request

    http://pairful.com/api/groups/list?session_id=abc 

### Example Response

    {グループ+リストのレスポンス例}

## POST groups#create

グループを作成

param | require | description
------|---------|------
session_id| o | セッションID
group[xxx]| o | 更新するグループのパラメータ

### Example Request

    http://pairful.com/api/groups/create 

### Example Response

    {単独グループのレスポンス例(後述)}

## POST groups#update

グループを更新

param | require | description
------|---------|------
session_id| o | セッションID
group[xxx]| o | 更新するグループのパラメータ

### Example Request

    http://pairful.com/api/groups/update

### Example Response

    {単独グループのレスポンス例(後述)}

## POST friends#create

友達を作成

param | require | description
------|---------|------
session_id| o | セッションID
friend[xxx]| o | 友達のパラメータ

### Example Request

    http://pairful.com/api/friends/create 

### Example Response

    {プロフィール/Friendの例(後述)}

## POST friends#update

友達を更新

param | require | description
------|---------|------
session_id| o | セッションID
id| o | Friend ID
friend[xxx]| o | 友達のパラメータ

### Example Request

    http://pairful.com/api/friends/(:id)/update

### Example Response

    {プロフィール/Friendの例(後述)}

## POST friends#destroy

友達を削除

param | require | description
------|---------|------
session_id| o | セッションID
id| o | Friend ID

### Example Request

    http://pairful.com/api/friends/(:id)/destroy 

### Example Response

    {単独ユーザーのレスポンス例(後述)}

## GET images#list

メイン画像の一覧を取得

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件  

### Example Request

    http://pairful.com/api/images/list?session_id=abc 

### Example Response

    {"status":"ok","images":[{"created_at":"2013-04-04T08:24:11Z","id":361,"is_main":true,"order_number":0,"user_id":702,"url":"https://pairful-development.s3.amazonaws.com/pairful/image/20130404/361.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365078609&Signature=8f1aqjMVrdp0Qh5VWxn3waMyz8I%3D"},{"created_at":"2013-04-04T08:24:11Z","id":351,"is_main":true,"order_number":0,"user_id":701,"url":"https://pairful-development.s3.amazonaws.com/pairful/image/20130404/351.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365078609&Signature=TVKkMAgfo%2Bu6LTTxVbNfFEG3uuI%3D"}],"current_page":1,"last_page":false}

## POST images#create

Imageを作成しアップロードするためののurlとパラメータを得る。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/images/create 

### Example Response

    {"status":"ok","url":"https://pairful-development.s3.amazonaws.com/","fields":{"AWSAccessKeyId":"AKIAIOQ4BVQW426SIRFA","key":"pairful/image/20130404/211.png","policy":"eyJleHBpcmF0aW9uIjoiMjAxMy0wNC0wNFQxMzo1NDoyNFoiLCJjb25kaXRpb25zIjpbeyJidWNrZXQiOiJwYWlyZnVsLWRldmVsb3BtZW50In0seyJrZXkiOiJwYWlyZnVsL2ltYWdlLzIwMTMwNDA0LzIxMS5wbmcifSx7ImFjbCI6IiJ9XX0=","signature":"uEPmU6R3fJvv5gQQUt9gImZTE+s=","acl":""}}

## POST images#destroy

画像を削除する

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
id| o | 画像ID

### Example Request

    http://pairful.com/api/images/(:id)/destroy 

### Example Response
    {"status":"ok"}
    {"status":"ng", "code":"permission_denied"}

## POST images#set_main

画像をメインにする

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
id| o | 画像ID

### Example Request

    http://pairful.com/api/images/(:id)/set_main

### Example Response

    {"status":"ok"}
    {"status":"ng", "code":"permission_denied"}
    {"status":"ng", "code":"not_found"}

## GET likes#list

「いいね」をした(された)ユーザーのリストを取得。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件
type| - | 'liked'(いいねをしてくれたユーザー)

### Example Request

    http://pairful.com/api/likes/list?session_id=abc 
    http://pairful.com/api/likes/list?session_id=abc&type=liked

### Example Response

    {後述:ユーザーリストのレスポンス例}

## GET matches#list

マッチングしたユーザーのリストを取得。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件  

### Example Request

    http://pairful.com/api/matches/list?session_id=abc 

### Example Response

    {後述:ユーザーリストのレスポンス例}

## POST likes#create

特定のユーザーに「いいね」をする。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
target_id| o | 相手のユーザーID

### Example Request

    http://pairful.com/api/likes/create

### Example Response

    {"status":"ok"}

## GET favorites#list

「お気に入り」のユーザーのリストを取得。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件  

### Example Request

    http://pairful.com/api/favorites/list?session_id=abc 

### Example Response

    {後述:ユーザーリストのレスポンス例}

## POST favorites#create

特定のユーザーを「お気に入り」にする。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
target_id| o | 相手のユーザーID

### Example Request

    http://pairful.com/api/favorites/create

### Example Response

    {"status":"ok"}

## POST favorites#destroy

「お気に入り」を解除する。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
target_id| o | 相手のユーザーID

### Example Request

    http://pairful.com/api/favorites/destroy

### Example Response

    {"status":"ok"}

## GET messages#list

特定のユーザーとのトークのリストを取得。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
target_id| o | 相手のユーザーID
page| - | 取得するデータのオフセット値　デフォルトは1
per| - | 取得する最大件数 デフォルトは25件  

### Example Request

    http://pairful.com/api/messages/list?session_id=abc&target_id=2

### Example Response

    {"status":"ok","messages":[{"body":"Qui adipisci dolorum architecto tenetur voluptatibus voluptatem molestias dolorem sunt sequi at.","created_at":"2013-04-04T14:35:05Z","id":4,"match_id":12,"talk_key":"1_2","updated_at":"2013-04-04T14:35:05Z","match":{"can_open_profile":false,"created_at":"2013-04-04T14:35:05Z","id":12,"messages_count":13,"target_id":1,"updated_at":"2013-04-04T14:35:05Z","user_id":2}},{"body":"Sed et omnis quo et aut error in perspiciatis ipsum et.","created_at":"2013-04-04T14:35:05Z","id":5,"match_id":11,"talk_key":"1_2","updated_at":"2013-04-04T14:35:05Z","match":{"can_open_profile":false,"created_at":"2013-04-04T14:35:05Z","id":11,"messages_count":7,"target_id":2,"updated_at":"2013-04-04T14:35:05Z","user_id":1}}],"current_page":1,"last_page":true}

## POST messages#create

特定のユーザーにメッセージを送る

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
target_id| o | 相手のユーザーID
body| o | メッセージの内容

### Example Request

    http://pairful.com/api/messages/create

### Example Response

    {"status":"ok"}

## GET items#list

購入可能なアイテムのリスト

    http://pairful.com/api/items/list?session_id=abc

### Example Response

    {未}

## GET receipts#list

In App Purchaceの購入履歴

### Paremeters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/receipts/list?session_id=abc

### Example Response

    {未}

## POST receipts#validate

In App Purchaceのレシートを確認してアイテムを購入する

### Paremeters

param | require | description
------|---------|------
session_id| o | セッションID
receipt_data| o | レシート

### Example Request

    http://pairful.com/api/receipts/list

### Example Response

    {未}

## POST points#add

ポイント付与

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
amount| o | ポイント付与量

### Example Request

    http://pairful.com/api/points/add

### Example Response
    
    {"status":"ok","point":178}

## POST points#consume

ポイントを使う

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
amount| o | ポイント消費量

### Example Request

    http://pairful.com/api/points/consume

### Example Response

    {"status":"ok","point":158}

## GET infos#list

運営からのお知らせ、個人ユーザーへの通達。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/infos/list?session_id=abc

### Example Response
    
    {"status":"ok","point":178}



## 単独ユーザーのレスポンス例

    {
        "login_bonus": 10, 
        "session": "abc", 
        "status": "ok", 
        "user": {
            "last_login_at": "2013-04-13T13:03:49Z", 
            "like_point": 5, 
            "point": 213, 
            "profile": {
                "age": 16, 
                "alcohol": 2, 
                "birthplace": 38, 
                "blood_type": "B", 
                "characters": [
                    {
                        "id": 192, 
                        "name": "仕事好き"
                    }, 
                    {
                        "id": 187, 
                        "name": "謙虚"
                    }, 
                    {
                        "id": 176, 
                        "name": "決断力がある"
                    }
                ], 
                "created_at": "2013-04-13T13:03:08Z", 
                "dislike": "Aliquid dolor esse ipsam.", 
                "gender": 0, 
                "group_id": null, 
                "height": 153, 
                "hobbies": [
                    {
                        "id": 119, 
                        "name": "料理"
                    }, 
                    {
                        "id": 122, 
                        "name": "ショッピング゙"
                    }, 
                    {
                        "id": 133, 
                        "name": "ゲーム"
                    }
                ], 
                "holiday": 1, 
                "id": 413, 
                "images": [
                    {
                        "created_at": "2013-04-13T13:03:08Z", 
                        "id": 422, 
                        "is_main": false, 
                        "member_id": 413, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/422.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365858239&Signature=LLeC%2Bx6Yp1oMaWHMDKRSmbwpULw%3D"
                    }, 
                    {
                        "created_at": "2013-04-13T13:03:08Z", 
                        "id": 423, 
                        "is_main": false, 
                        "member_id": 413, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/423.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365858239&Signature=azazOts92ClK7EerOF8%2BwrQkVo8%3D"
                    }, 
                    {
                        "created_at": "2013-04-13T13:03:08Z", 
                        "id": 424, 
                        "is_main": false, 
                        "member_id": 413, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/424.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365858239&Signature=%2BnkpHlNkXKUxvT%2BfU6Ych6aDYKU%3D"
                    }, 
                    {
                        "created_at": "2013-04-13T13:03:08Z", 
                        "id": 425, 
                        "is_main": false, 
                        "member_id": 413, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/425.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365858239&Signature=RPk3KScPQ1skS8P4FfcUPmA1RSg%3D"
                    }, 
                    {
                        "created_at": "2013-04-13T13:03:08Z", 
                        "id": 421, 
                        "is_main": true, 
                        "member_id": 413, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/421.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365858239&Signature=NSy5%2BwAWSjbNQ73mozmdvistMT4%3D"
                    }
                ], 
                "income": 1, 
                "industry": 0, 
                "introduction": "Aut commodi iste voluptatem beatae voluptatem veniam mollitia ipsam ut reprehenderit doloribus voluptatem vero nobis atque dolores nesciunt at molestiae magni voluptate consequuntur corrupti eius minus aspernatur et excepturi quisquam aut distinctio.", 
                "job": 10, 
                "job_description": "Sed ut.", 
                "marital_history": 0, 
                "marriage_time": 0, 
                "nickname": "taro", 
                "prefecture": 23, 
                "proportion": 3, 
                "roommate": "1", 
                "school": null, 
                "smoking": 1, 
                "sociability": 0, 
                "specialities": [
                    {
                        "id": 26, 
                        "name": "茶道"
                    }, 
                    {
                        "id": 29, 
                        "name": "早食い"
                    }, 
                    {
                        "id": 27, 
                        "name": "華道"
                    }
                ], 
                "status": 1, 
                "updated_at": "2013-04-13T13:03:08Z", 
                "user_id": 1, 
                "workplace": "South Katheryn"
            }, 
            "status": "1"
        }
    }

## ユーザーリストのレスポンス例

    {
        "current_page": 1, 
        "users": [
            {
                "address": "Pearline", 
                "age": 34, 
                "alcohol": 3, 
                "birthplace": "22", 
                "blood_type": "O", 
                "certification": "???", 
                "certification_status": "???", 
                "character": null, 
                "constellation": 0, 
                "contract_type": "???", 
                "country": "Japan", 
                "created_at": "2013-04-04T07:49:58Z", 
                "dislike": "goki", 
                "first_login_at": "2012-10-04T07:49:58Z", 
                "gender": 1, 
                "have_child": 0, 
                "height": 181, 
                "hobby": null, 
                "holiday": 3, 
                "id": 565, 
                "images": [
                    {
                        "created_at": "2013-04-04T07:49:59Z", 
                        "id": 206, 
                        "is_main": true, 
                        "order_number": 0, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130404/206.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365062978&Signature=ErlR03bPUgb4avR%2BKPtB9fu8dR8%3D", 
                        "user_id": 565
                    }, 
                    {
                        "created_at": "2013-04-04T07:49:59Z", 
                        "id": 207, 
                        "is_main": false, 
                        "order_number": 1, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130404/207.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365062978&Signature=U12l1YZhzPgJTk8MfIYsf9lbwqc%3D", 
                        "user_id": 565
                    }, 
                    {
                        "created_at": "2013-04-04T07:49:59Z", 
                        "id": 208, 
                        "is_main": false, 
                        "order_number": 2, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130404/208.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365062978&Signature=%2FNeqzd7t5MC%2FwL8%2FMCg4WDRshZ4%3D", 
                        "user_id": 565
                    }, 
                    {
                        "created_at": "2013-04-04T07:49:59Z", 
                        "id": 209, 
                        "is_main": false, 
                        "order_number": 3, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130404/209.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365062978&Signature=i0BwMVxtAYv0sJeMRE7xj%2FGXfhQ%3D", 
                        "user_id": 565
                    }, 
                    {
                        "created_at": "2013-04-04T07:49:59Z", 
                        "id": 210, 
                        "is_main": false, 
                        "order_number": 4, 
                        "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130404/210.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365062978&Signature=D16pLPyxmLl5Xh8rb1OwAP%2Bk67U%3D", 
                        "user_id": 565
                    }
                ], 
                "income": 3, 
                "industry": 0, 
                "introduction": "Eum eos assumenda vitae nobis eligendi maxime numquam animi quae qui aliquam hic commodi.", 
                "invitation_code": "", 
                "job": 25, 
                "job_description": "クリエイター ", 
                "language": "Japanese", 
                "last_login_at": "2013-03-26T07:49:58Z", 
                "like_point": 0, 
                "login_token": "db9qa63nld", 
                "marital_history": 0, 
                "marriage_time": 0, 
                "nickname": "Darron", 
                "prefecture": 38, 
                "profile_status": "???", 
                "proportion": 1, 
                "public_status": "???", 
                "qualification": "普通自動車免許", 
                "relationship": 0, 
                "roommate": "???", 
                "school": null, 
                "school_name": "辻調理師専門学校", 
                "smoking": 0, 
                "sociability": "???", 
                "speciality": null, 
                "updated_at": "2013-04-04T07:49:58Z", 
                "want_child": 0, 
                "workplace": "渋谷区"
            }
        ], 
        "last_page": true, 
        "status": "ok"
    }

## プロフィール/Friendの例

    {
        "profile": {
            "characters": [
                {
                    "id": 192, 
                    "name": "仕事好き"
                }, 
                {
                    "id": 187, 
                    "name": "謙虚"
                }, 
                {
                    "id": 176, 
                    "name": "決断力がある"
                }
            ], 
            "hobbies": [
                {
                    "id": 119, 
                    "name": "料理"
                }, 
                {
                    "id": 122, 
                    "name": "ショッピング゙"
                }, 
                {
                    "id": 133, 
                    "name": "ゲーム"
                }
            ], 
            "id": 413, 
            "images": [
                {
                    "created_at": "2013-04-13T13:03:08Z", 
                    "id": 422, 
                    "is_main": false, 
                    "member_id": 413, 
                    "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/422.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365861793&Signature=kTeKsO13dX0lgh09HOyUooh8dvU%3D"
                }, 
                {
                    "created_at": "2013-04-13T13:03:08Z", 
                    "id": 423, 
                    "is_main": false, 
                    "member_id": 413, 
                    "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/423.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365861793&Signature=SXfovdV4bXeFAqMWpNO%2FdYbeltw%3D"
                }, 
                {
                    "created_at": "2013-04-13T13:03:08Z", 
                    "id": 424, 
                    "is_main": false, 
                    "member_id": 413, 
                    "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/424.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365861793&Signature=YZLygKJDbRxrmVKtBSY3py7A%2Fiw%3D"
                }, 
                {
                    "created_at": "2013-04-13T13:03:08Z", 
                    "id": 425, 
                    "is_main": false, 
                    "member_id": 413, 
                    "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/425.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365861793&Signature=LfF5lXam6AuTktsEidjbf7kshZ4%3D"
                }, 
                {
                    "created_at": "2013-04-13T13:03:08Z", 
                    "id": 421, 
                    "is_main": true, 
                    "member_id": 413, 
                    "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/421.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365861793&Signature=lcxAY491o7ejgbqeurOlk5FIMeU%3D"
                }
            ], 
            "specialities": [
                {
                    "id": 26, 
                    "name": "茶道"
                }, 
                {
                    "id": 29, 
                    "name": "早食い"
                }, 
                {
                    "id": 27, 
                    "name": "華道"
                }
            ]
        }, 
        "status": "ok"
    }


## グループのレスポンス例

    {
        "group": {
            "area": "Moriahstad", 
            "friends": [
                {
                    "age": 24, 
                    "alcohol": 2, 
                    "birthplace": 26, 
                    "blood_type": "B", 
                    "characters": [
                        {
                            "id": 171, 
                            "name": "穏やか"
                        }, 
                        {
                            "id": 199, 
                            "name": "気か"
                        }, 
                        {
                            "id": 169, 
                            "name": "ロマンチスト"
                        }
                    ], 
                    "created_at": "2013-04-13T13:03:09Z", 
                    "dislike": "Odio ut fugit amet non.", 
                    "gender": 1, 
                    "group_id": 83, 
                    "height": 165, 
                    "hobbies": [
                        {
                            "id": 137, 
                            "name": "フィットネス"
                        }, 
                        {
                            "id": 135, 
                            "name": "ギャンブル"
                        }, 
                        {
                            "id": 117, 
                            "name": "カラオケ"
                        }
                    ], 
                    "holiday": 2, 
                    "id": 415, 
                    "images": [], 
                    "income": 6, 
                    "industry": 0, 
                    "introduction": "Veniam voluptas et corporis aut quibusdam autem quo modi adipisci rerum neque mollitia perspiciatis dolorem consequatur doloribus illo culpa temporibus corrupti eum non commodi quia aut asperiores dolores sed id odio voluptate aut dolorem.", 
                    "job": 5, 
                    "job_description": "Necessitatibus asperiores expedita dolores.", 
                    "marital_history": 0, 
                    "marriage_time": 0, 
                    "nickname": "Amy", 
                    "prefecture": 28, 
                    "proportion": 1, 
                    "roommate": "1", 
                    "school": null, 
                    "smoking": 1, 
                    "sociability": 0, 
                    "specialities": [
                        {
                            "id": 26, 
                            "name": "茶道"
                        }, 
                        {
                            "id": 27, 
                            "name": "華道"
                        }, 
                        {
                            "id": 25, 
                            "name": "スポーツ"
                        }
                    ], 
                    "status": 1, 
                    "updated_at": "2013-04-13T13:03:09Z", 
                    "user_id": null, 
                    "workplace": "Vonstad"
                }
            ], 
            "head_count": 2, 
            "id": 83, 
            "leader": {
                "access_token": "abcdefg", 
                "contract_type": null, 
                "created_at": "2013-04-13T13:03:08Z", 
                "device_token": "r9sof5esgzg2jiengllljs9gktrozc", 
                "email": "amparo.ledner@ondricka.name", 
                "facebook_id": 1234567, 
                "gender": 0, 
                "id": 1, 
                "invitation_code": "", 
                "last_login_at": "2013-04-13T13:45:54Z", 
                "like_point": 5, 
                "point": 213, 
                "profile": {
                    "age": 16, 
                    "alcohol": 2, 
                    "birthplace": 38, 
                    "blood_type": "B", 
                    "characters": [
                        {
                            "id": 192, 
                            "name": "仕事好き"
                        }, 
                        {
                            "id": 187, 
                            "name": "謙虚"
                        }, 
                        {
                            "id": 176, 
                            "name": "決断力がある"
                        }
                    ], 
                    "created_at": "2013-04-13T13:03:08Z", 
                    "dislike": "Aliquid dolor esse ipsam.", 
                    "gender": 0, 
                    "group_id": null, 
                    "height": 153, 
                    "hobbies": [
                        {
                            "id": 119, 
                            "name": "料理"
                        }, 
                        {
                            "id": 122, 
                            "name": "ショッピング゙"
                        }, 
                        {
                            "id": 133, 
                            "name": "ゲーム"
                        }
                    ], 
                    "holiday": 1, 
                    "id": 413, 
                    "images": [
                        {
                            "created_at": "2013-04-13T13:03:08Z", 
                            "id": 422, 
                            "is_main": false, 
                            "member_id": 413, 
                            "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/422.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365860764&Signature=x08z3bL7SSyYmoqCylzJii9GdcU%3D"
                        }, 
                        {
                            "created_at": "2013-04-13T13:03:08Z", 
                            "id": 423, 
                            "is_main": false, 
                            "member_id": 413, 
                            "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/423.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365860764&Signature=b53Y0GFknhmABiYfi%2F3IEvzZdP0%3D"
                        }, 
                        {
                            "created_at": "2013-04-13T13:03:08Z", 
                            "id": 424, 
                            "is_main": false, 
                            "member_id": 413, 
                            "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/424.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365860764&Signature=TMfT4QQ8VpdAs6Yl8vxe2bzj8ss%3D"
                        }, 
                        {
                            "created_at": "2013-04-13T13:03:08Z", 
                            "id": 425, 
                            "is_main": false, 
                            "member_id": 413, 
                            "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/425.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365860764&Signature=JdbMJrJwHbIWgEHrjzO2IsC2lis%3D"
                        }, 
                        {
                            "created_at": "2013-04-13T13:03:08Z", 
                            "id": 421, 
                            "is_main": true, 
                            "member_id": 413, 
                            "url": "https://pairful-development.s3.amazonaws.com/pairful/image/20130413/421.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1365860764&Signature=Q4KO0tCjJDyCD0OS5HA8wSxQWkw%3D"
                        }
                    ], 
                    "income": 1, 
                    "industry": 0, 
                    "introduction": "Aut commodi iste voluptatem beatae voluptatem veniam mollitia ipsam ut reprehenderit doloribus voluptatem vero nobis atque dolores nesciunt at molestiae magni voluptate consequuntur corrupti eius minus aspernatur et excepturi quisquam aut distinctio.", 
                    "job": 10, 
                    "job_description": "Sed ut.", 
                    "marital_history": 0, 
                    "marriage_time": 0, 
                    "nickname": "taro", 
                    "prefecture": 23, 
                    "proportion": 3, 
                    "roommate": "1", 
                    "school": null, 
                    "smoking": 1, 
                    "sociability": 0, 
                    "specialities": [
                        {
                            "id": 26, 
                            "name": "茶道"
                        }, 
                        {
                            "id": 29, 
                            "name": "早食い"
                        }, 
                        {
                            "id": 27, 
                            "name": "華道"
                        }
                    ], 
                    "status": 1, 
                    "updated_at": "2013-04-13T13:03:08Z", 
                    "user_id": 1, 
                    "workplace": "South Katheryn"
                }, 
                "status": "1", 
                "updated_at": "2013-04-13T13:45:54Z"
            }, 
            "max_age": 38, 
            "min_age": 25, 
            "opening_hour": "2000-01-01T13:03:06Z", 
            "relationship": "harum", 
            "request": "Dicta sit facere eaque illum.", 
            "status": 1, 
            "target_age_range": 0, 
            "user_id": 1
        }, 
        "status": "ok"
    }



