class Admin::HobbiesController < AdminController
  layout "hobby"

  def index
    @hobbies = Hobby.page(params[:page])
  end

  def show
    @hobby = Hobby.find(params[:id])
  end

  def new
    @hobby = Hobby.new
  end

  def create
    @hobby = Hobby.new(params[:hobby])

    respond_to do |format|
      if @hobby.save
        format.html { redirect_to [:admin, @hobby], notice: 'Hobby was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @hobby = Hobby.find(params[:id])
  end

  def update
    @hobby = Hobby.find(params[:id])

    respond_to do |format|
      if @hobby.update_attributes(params[:hobby])
        format.html { redirect_to [:admin, @hobby] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.destroy
    redirect_to admin_hobbies_url, :notice => "Successfully destroyed hobby."
  end
end
