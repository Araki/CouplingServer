# -*r coding: utf-8 -*-

module ModelHelper
=begin
多対多の関連を保存する。パラメータで入力されるidの配列の要素数が0以上、制限された数以下であれば
現在の関連を全て削除して関連を作成し直す。
=end  
  def update_associations(association, params)
    klass = association.to_s.singularize.camelize.constantize
    ids = params[association]
    if ids && ids.length > 0
      limit = configatron.send("#{association}_limit") 
      if ids.length <= limit
        self.send(association).delete_all
        self.send(association) << klass.where(:id => ids)
      else
        self.errors[:base] << "Couldn't add #{ids.length} #{association} max #{limit}."
        raise ActiveRecord::RecordInvalid.new self
      end
    end
  end
end