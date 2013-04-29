class Admin::SessionsController < AdminController
  layout "session"

  def index
    @sessions = Session.page(params[:page])
  end

  def show
    @session = Session.find(params[:id])
  end

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])

    respond_to do |format|
      if @session.save
        format.html { redirect_to [:admin, @session], notice: 'Session was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @session = Session.find(params[:id])
  end

  def update
    @session = Session.find(params[:id])

    respond_to do |format|
      if @session.update_attributes(params[:session])
        format.html { redirect_to [:admin, @session] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @session = Session.find(params[:id])
    if params[:before] == 'true'
      Session.destroy_all(["created_at < ?", @session.created_at])
    else
      @session.destroy
    end
    redirect_to admin_sessions_url, :notice => "Successfully destroyed info."
  end
end
