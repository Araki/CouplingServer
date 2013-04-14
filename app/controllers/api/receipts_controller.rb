# coding:utf-8
class Api::ReceiptsController < Api::BaseController

  def list
    receipts = Kaminari.paginate_array(@user.receipts).page(params[:page]).per(params[:per])
    render_pagenate_data(:receipts, receipts, {:only => [:created_at]})
  end

  def validate
    receipt_data = params[:receipt_data]
    render_ng("invalid_receipt") and return if Receipt.find_by_receipt_code(receipt_data).present?

    receipt =Receipt.new(:user_id => @user.id, :receipt_code => receipt_data)
    if receipt.valid_and_save
      render_ok({item: receipt.item})
    else
      render_ng(receipt.errors)
    end
  end
end