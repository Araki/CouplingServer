class Admin::ReceiptsController < AdminController

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @receipts = @user.receipts.page(params[:page])
    else
      @receipts = Receipt.page(params[:page])
    end
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy
    redirect_to admin_receipts_url, :notice => "Successfully destroyed receipt."
  end
end
