# coding:utf-8

class Receipt < ActiveRecord::Base
  attr_accessible :receipt_code, :user_id, :item_id

  belongs_to :user
  belongs_to :item, :counter_cache => true

  default_scope order('created_at DESC')

  #itunes storeで発行されたreceiptコードを受け取り有効なレシートかを調べて確認出来れば
  #ポイントを追加して、Receiptを生成する。

  # IAPのレシート例
  # {"receipt": {
  #     "original_purchase_date_pst":"2012-10-11 07:45:40 America/Los_Angeles", 
  #     "unique_identifier":"4d69cc362c5c58ce62da68ee43721ea670907bad",
  #     "original_transaction_id":"1000000057005439",
  #     "expires_date":"1350157508197", 
  #     "transaction_id":"1000000055076747", 
  #     "quantity":"1",
  #     "product_id":"com.notkeepingitreal.fizzbuzz.subscription.autorenew1m",
  #     "original_purchase_date_ms":"1349966740000",
  #     "bid":"com.notkeepingitreal.fizzbuzz",
  #     "web_order_line_item_id":"1000000026553289",
  #     "bvrs":"1.0",
  #     "expires_date_formatted":"2012-10-13 19:45:08 Etc/GMT",
  #     "purchase_date":"2012-10-13 19:40:08 Etc/GMT",
  #     "purchase_date_ms":"1350157208197",
  #     "expires_date_formatted_pst":"2012-10-13 12:45:08 America/Los_Angeles",
  #     "purchase_date_pst":"2012-10-13 12:40:08 America/Los_Angeles",
  #     "original_purchase_date":"2012-10-11 14:45:40 Etc/GMT", "item_id":"570504929"},
  #     "latest_receipt_info":{"original_purchase_date_pst":"2012-10-11 07:45:40 America/Los_Angeles",
  #     "item_id":"570504929"},
  #  "status":0,
  #  "latest_receipt":"junk="
  # }

  def valid_and_save
    iap_receipt = Itunes::Receipt.verify! self.receipt_code, :allow_sandbox

    item = Item.find_by_pid(iap_receipt.product_id)
    raise ActiveRecord::RecordNotFound.new("Item Not Found") if item.nil?

    ActiveRecord::Base.transaction do
      quantity = iap_receipt.quantity || 1
      self.user.add_point(item.point * quantity)
      self.item_id = item.id
      self.save!
    end
  end

  def as_json(options = {})
    json = super(options)
    json['item'] = self.item.title
    json
  end  
end
