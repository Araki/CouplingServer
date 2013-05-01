require "spec_helper"

describe Admin::GroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/groups").should route_to(controller: "admin/groups", action: "index")
    end

    it "routes to #show" do
      get("/admin/groups/5").should route_to(controller: "admin/groups", action: "show", id: "5")
    end

    it "routes to #edit" do
      get("/admin/groups/5/edit").should route_to(controller: "admin/groups", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/groups/5").should route_to(controller: "admin/groups", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/groups/5").should route_to(controller: "admin/groups", action: "destroy", id: "5")
    end
  end
end
