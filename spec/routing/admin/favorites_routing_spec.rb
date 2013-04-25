require "spec_helper"

describe Admin::FavoritesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/users/3/favorites").should route_to(controller: "admin/favorites", action: "index", user_id: "3")
    end

    it "routes to #destroy" do
      delete("/admin/users/3/favorites/5").should route_to(controller: "admin/favorites", action: "destroy", user_id: "3", id: "5")
    end
  end
end
