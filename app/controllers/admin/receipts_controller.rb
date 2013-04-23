class Admin::ReceiptsController < AdminController

  def index
    @receipts = Receipt.page(params[:page])
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
