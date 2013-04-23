class Admin::ItemsController < AdminController

  def index
    @items = Item.page(params[:page])
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to [:admin, @item], notice: 'Item was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to [:admin, @item] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_url, :notice => "Successfully destroyed item."
  end
end
