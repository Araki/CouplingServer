class AdminController < ActionController::Base
  layout "admin"
  helper :layout
  protect_from_forgery
end
