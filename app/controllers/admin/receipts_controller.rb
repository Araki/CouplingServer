class Admin::ReceiptsController < AdminController
  layout "receipt"
  before_filter :load_user

  def index
    if params[:user_id]
      @receipts = @user.receipts.page(params[:page])
    else
      @receipts = Receipt.page(params[:page])
    end
  end

  def show
    @receipt = Receipt.find(params[:id])
  end

  def new
    @receipt = Receipt.new(user_id: (@user.present? ? @user.id : nil))
  end

  def create
    @receipt = Receipt.new(params[:receipt])

    respond_to do |format|
      if @receipt.save
        if @user.present?
          format.html { redirect_to [:admin, @user, @receipt], notice: 'Receipt was successfully created.' }
        else
          format.html { redirect_to [:admin, @receipt], notice: 'Receipt was successfully created.' }
        end
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @receipt = Receipt.find(params[:id])
  end

  def update
    @receipt = Receipt.find(params[:id])

    respond_to do |format|
      if @receipt.update_attributes(params[:receipt])
        if @user.present?
          format.html { redirect_to [:admin, @user, @receipt], notice: 'Receipt was successfully created.' }
        else
          format.html { redirect_to [:admin, @receipt] }
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @receipt = Receipt.find(params[:id])
    @receipt.destroy
    if @user.present?
      redirect_to admin_user_receipts_path(@user), :notice => "Successfully destroyed info."
    else
      redirect_to admin_receipts_url, :notice => "Successfully destroyed info."
    end
  end

  private 
  def load_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end
end
