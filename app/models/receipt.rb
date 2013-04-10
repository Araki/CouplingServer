# coding:utf-8

class Receipt < ActiveRecord::Base
  attr_accessible :receipt_code, :user_id, :item_id

  belongs_to :user, :dependent => :destroy
  belongs_to :item, :dependent => :destroy, :counter_cache => true

  #itunes storeで発行されたreceiptコードを受け取り有効なレシートかを調べて確認出来れば
  #ポイントを追加して、Receiptを生成する。
  def valid_and_save
    begin
      iap_receipt = Itunes::Receipt.verify! self.receipt_code, :allow_sandbox
      item =Item.find_by_pid(iap_receipt.product_id)
      if item.nil?
        self.errors.add :base, "item_not_found"
        return false
      end
      ActiveRecord::Base.transaction do
        unless self.user.add_point(item.point)
          raise ActiveRecord::RecordInvalid.new(self.user)
        end
        self.item_id = item.id
        self.save!
      end
      true

    rescue ActiveRecord::RecordInvalid => e
      self.errors.add :base, "internal_server_error"
      false
    rescue StandardError => e
      self.errors.add :base, "iap_server_error"
      false
    end
  end

  def as_json(options = {})
    json = super(options)
    json['item'] = self.item.title
    json
  end  
end
