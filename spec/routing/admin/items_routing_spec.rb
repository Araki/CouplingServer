require "spec_helper"

describe Admin::ItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/items").should route_to(controller: "admin/items", action: "index")
    end

    it "routes to #show" do
      get("/admin/items/5").should route_to(controller: "admin/items", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/items/new").should route_to(controller: "admin/items", action: "new")
    end

    it "routes to #create" do
      post("/admin/items").should route_to(controller: "admin/items", action: "create")
    end

    it "routes to #edit" do
      get("/admin/items/5/edit").should route_to(controller: "admin/items", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/items/5").should route_to(controller: "admin/items", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/items/5").should route_to(controller: "admin/items", action: "destroy", id: "5")
    end
  end
end
