require "spec_helper"

describe Api::FavoritesController do
  describe "routing" do

    it "routes to #list" do
      get("/api/favorites/list").should route_to(controller: "api/favorites", action: "list")
    end

    it "routes to #create" do
      post("/api/favorites/create").should route_to(controller: "api/favorites", action: "create")
    end

    it "routes to #destroy" do
      post("/api/favorites/destroy").should route_to(controller: "api/favorites", action: "destroy")
    end
  end
end
