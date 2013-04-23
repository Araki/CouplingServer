require "spec_helper"

describe Api::FriendsController do
  describe "routing" do

    it "routes to #show" do
      get("/api/friends/5/show").should route_to(controller: "api/friends", action: "show", id: "5")
    end

    it "routes to #create" do
      post("/api/friends/create").should route_to(controller: "api/friends", action: "create")
    end

    it "routes to #update" do
      post("/api/friends/5/update").should route_to(controller: "api/friends", action: "update", id: "5")
    end

    it "routes to #destroy" do
      post("/api/friends/5/destroy").should route_to(controller: "api/friends", action: "destroy", id: "5")
    end
  end
end
