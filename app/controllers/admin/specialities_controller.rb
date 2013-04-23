class Admin::SpecialitiesController < AdminController

  def index
    @specialities = Speciality.page(params[:page])
  end

  def show
    @speciality = Speciality.find(params[:id])
  end

  def new
    @speciality = Speciality.new
  end

  def create
    @speciality = Speciality.new(params[:speciality])

    respond_to do |format|
      if @speciality.save
        format.html { redirect_to [:admin, @speciality], notice: 'Speciality was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @speciality = Speciality.find(params[:id])
  end

  def update
    @speciality = Speciality.find(params[:id])

    respond_to do |format|
      if @speciality.update_attributes(params[:speciality])
        format.html { redirect_to [:admin, @speciality] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @speciality = Speciality.find(params[:id])
    @speciality.destroy
    redirect_to admin_specialities_url, :notice => "Successfully destroyed speciality."
  end
end
