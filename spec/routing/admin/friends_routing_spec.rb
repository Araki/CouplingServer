require "spec_helper"

describe Admin::FriendsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/friends").should route_to(controller: "admin/friends", action: "index")
    end

    it "routes to #show" do
      get("/admin/friends/5").should route_to(controller: "admin/friends", action: "show", id: "5")
    end
    
    it "routes to #edit" do
      get("/admin/friends/5/edit").should route_to(controller: "admin/friends", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/friends/5").should route_to(controller: "admin/friends", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/friends/5").should route_to(controller: "admin/friends", action: "destroy", id: "5")
    end
  end
end
