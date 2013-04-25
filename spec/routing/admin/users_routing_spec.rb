require "spec_helper"

describe Admin::UsersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/users").should route_to(controller: "admin/users", action: "index")
    end

    it "routes to #show" do
      get("/admin/users/5").should route_to(controller: "admin/users", action: "show", id: "5")
    end
    
    it "routes to #edit" do
      get("/admin/users/5/edit").should route_to(controller: "admin/users", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/users/5").should route_to(controller: "admin/users", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/users/5").should route_to(controller: "admin/users", action: "destroy", id: "5")
    end
  end
end
