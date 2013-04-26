class Admin::CharactersController < AdminController
  layout "character"

  def index
    @characters = Character.page(params[:page])
  end

  def show
    @character = Character.find(params[:id])
  end

  def new
    @character = Character.new
  end

  def create
    @character = Character.new(params[:character])

    respond_to do |format|
      if @character.save
        format.html { redirect_to [:admin, @character], notice: 'Character was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @character = Character.find(params[:id])
  end

  def update
    @character = Character.find(params[:id])

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to [:admin, @character] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @character = Character.find(params[:id])
    @character.destroy
    redirect_to admin_characters_url, :notice => "Successfully destroyed character."
  end
end
