## GET session/create

初期登録時に叩くAPI。Facebookのアクセストークンを投げると、セッションIDを生成して返す。

### Parameters

param | require | description
------|---------|------
access_token | o | Facebookのアクセストークン

### Example Request

    http://pairful.com/api/user/session/create?access_token=1234
***

    {"status":"ok","session":"lhzB_XmdfmEP","user":{"id":2,"facebook_id":1319832574,"profile_status":null,"email":null,"certification":null,"certification_status":null,"public_status":null,"first_login_at":null,"last_login_at":null,"invitation_code":null,"contract_type":null,"like_point":null,"point":null,"nickname":null,"introduction":null,"gender":null,"age":null,"country":null,"language":null,"address":null,"birthplace":null,"roommate":null,"height":null,"proportion":null,"constellation":null,"blood_type":null,"marital_history":null,"marriage_time":null,"want_child":null,"relationship":null,"have_child":null,"smoking":null,"alcohol":null,"industry":null,"job":null,"job_description":null,"workplace":null,"income":null,"qualification":null,"school":null,"holiday":null,"sociability":null,"character":null,"speciality":null,"hobby":null,"dislike":null,"login_token":null,"created_at":"2013-01-07T17:06:13Z","updated_at":"2013-01-07T17:06:13Z"}}

## GET session/verify

session_idが有効な場合、trueを、無効な場合、falseを返す。

### Parameters

param | require | description
------|---------|------
session_id| o |セッションID

### Example Request

    http://pairful.com/api/user/session/verify?session_id=1234
***

    {"status":"ok","session":"lhzB_XmdfmEP","user":{"id":2,"facebook_id":1319832574,"profile_status":null,"email":null,"certification":null,"certification_status":null,"public_status":null,"first_login_at":null,"last_login_at":null,"invitation_code":null,"contract_type":null,"like_point":null,"point":null,"nickname":null,"introduction":null,"gender":null,"age":null,"country":null,"language":null,"address":null,"birthplace":null,"roommate":null,"height":null,"proportion":null,"constellation":null,"blood_type":null,"marital_history":null,"marriage_time":null,"want_child":null,"relationship":null,"have_child":null,"smoking":null,"alcohol":null,"industry":null,"job":null,"job_description":null,"workplace":null,"income":null,"qualification":null,"school":null,"holiday":null,"sociability":null,"character":null,"speciality":null,"hobby":null,"dislike":null,"login_token":null,"created_at":"2013-01-07T17:06:13Z","updated_at":"2013-01-07T17:06:13Z"}}

## GET session/destroy

セッションIDを無効にする。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/user/session/destroy?session_id=#{session_id}
***

    {"status":"ok"}

## GET profile/show

user_idを指定するとそのユーザのプロフィールを返す。user_idを指定しなければセッションのユーザのプロフィールを返す。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
user_id| - | ユーザID

### Example Request

    http://pairful.com/api/user/profile/show?session_id=abcd1234
***

     {"status":"ok","id":2,"facebook_id":1319832574,"profile_status":null,"email":null,"certification":null,"certification_status":null,"public_status":null,"first_login_at":null,"last_login_at":null,"invitation_code":null,"contract_type":null,"like_point":null,"point":null,"nickname":null,"introduction":null,"gender":null,"age":null,"country":null,"language":null,"address":null,"birthplace":null,"roommate":null,"height":null,"proportion":null,"constellation":null,"blood_type":null,"marital_history":null,"marriage_time":null,"want_child":null,"relationship":null,"have_child":null,"smoking":null,"alcohol":null,"industry":null,"job":null,"job_description":null,"workplace":null,"income":null,"qualification":null,"school":null,"holiday":null,"sociability":null,"character":null,"speciality":null,"hobby":null,"dislike":null,"login_token":null,"created_at":"2013-01-07T17:06:13Z","updated_at":"2013-01-07T17:06:13Z"}

## POST profile/edit

自分のプロフィール情報を追加・更新する。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    POST /api/user/profile/edit
    session_id:abcd1234

## POST upload/image_parameter

画像アップロードするためののurlとパラメータを得る。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/user/upload/image_parameter?session_id=abcd1234
***

    {"status":"ok","url":"https://pairful-development.s3.amazonaws.com/","fields":{"AWSAccessKeyId":"AKIAIOQ4BVQW426SIRFA","key":"pairful/image/20130127/2.png","policy":"eyJleHBpcmF0aW9uIjoiMjAxMy0wMS0yN1QwODo0NjoyNFoiLCJjb25kaXRpb25zIjpbeyJidWNrZXQiOiJwYWlyZnVsLWRldmVsb3BtZW50In0seyJrZXkiOiJwYWlyZnVsL2ltYWdlLzIwMTMwMTI3LzIucG5nIn0seyJhY2wiOiIifV19","signature":"1hMMAGXxnSfhZdXNN+scpdkZUvI=","acl":""}}

## POST upload/image_url

画像ダウンロードするためのurlを得る。

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/user/upload/image_url?session_id=abcd1234
***

    {"status":"ok","url":"https://pairful-development.s3.amazonaws.com/pairful/image/20130127/2.png?AWSAccessKeyId=AKIAIOQ4BVQW426SIRFA&Expires=1359276504&Signature=gIHQxBs1ps7rz7ySJhHsk0K%2Bkt8%3D"}

## GET user/list

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID
filter_key| - | フィルターをかける条件のキーを指定する liked
filter_value| - | フィルターをかける条件の値を指定する true
start_index| - | 取得するデータのオフセット値　デフォルトは0
count| - | 取得する最大件数 デフォルトは50件  

### 仕様の変更を検討（天野：2012年10月20日）
* https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
* #{max_id} #{since_id}を指定してリストの読み込み範囲を指定するようにする
* #{start_index}と#{count}ではリアルタイムな更新があるとどこから読み込めばいいかわからなくなる。

### Example Request

    http://pairful.com/api/user/list?session_id=abcd1234&filter_by=liked&filter_value=true&start_index=0&count=5
***

    {"status":"ok","user":[]}

## POST like/add

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/user/like/add?session_id=abcd1234
***

## GET like/show

### Parameters

param | require | description
------|---------|------
session_id| o | セッションID

### Example Request

    http://pairful.com/api/user/like/show?session_id=abcd1234
***

    {"status":"ok","like":[]}

## POST message/new

特定のユーザーにメッセージを送る

### Parameters

param | require | description
------|---------|------
facebook_id| o | メッセージを送る相手のFacebookID
session_id| o | セッションID
message| o | メッセージの内容

### Example Request

    http://pairful.com/api/v1/user/talk/123456789
    session_id:abcd1234
    message:こんにちは

## GET messages

相手のFacebookIDを渡すと、その相手とのメッセージ履歴を返す。

### Parameters

param | require | description
------|---------|------
facebook_id| o | メッセージ相手のFacebookID
session_id| o | セッションID

### Example Request

    http://pairful.com/api/v1/user/talk/987654321?session_id=abcd1234
***

    {
        'talk-2':
        {
            'facebook_id':12345678,
            'message':'こんにちは'
        },
        'talk-1':
        {
            'facebook_id':987654321,
            'message':'はじめまして'
        }
    }

## POST buy/item

In App Purchace購入操作

### Paremeters

param | require | description
------|---------|------
facebook_id| o | 購入するユーザーのFacebookID。
session_id| o | セッションID
item_id| o | 購入するアイテムID
amount| o | 購入数
transaction_id| o | トランザクションID

### Example Request

    POST http://coupling.herokuapp.com/api/v1/iap/pay/#{facebook_id}/
	session_id:abcd1234
	item_id:3
	amount:1
	transaction_id:xxxxxxxxxxxxxxxxxxxxxx

## POST add/point

ポイント付与

### Parameters

param | require | description
------|---------|------
facebook_id| o | ポイントを付与する対象のFacebookID
session_id| o | セッションID
amount| o | ポイント付与量

### Example Request

    POST http://coupling.herokuapp.com/api/v1/point/add/#{facebook_id}/
    session_id:abcd1234
    amount:300

## POST consume/point

ポイントを使う

### Parameters

param | require | description
------|---------|------
facebook_id| o |  ポイントを使う対象のFacebookID。@meのみ
session_id| o | セッションID
amount| o | ポイント消費量

### Example Request

    POST http://coupling.herokuapp.com/api/v1/point/use/#{facebook_id}/
    session_id:abcd1234
    amount:300

## POST apns/create

APNSトークン登録

### Parameters
param | require | description
------|---------|------
facebook_id| o | ポイントを付与する対象のFacebookID
push_token| o | PUSH通知用のトークン

### Example Request

    POST http://coupling.herokuapp.com/api/v1/push/add/#{facebook_id}/
    session_id:abcd1234
    push_token:AbCdEfGhIj1234567890AbCdEfGhIj123
