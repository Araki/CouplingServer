require "spec_helper"

describe Admin::InfosController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/infos").should route_to(controller: "admin/infos", action: "index")
    end

    it "routes to #show" do
      get("/admin/infos/5").should route_to(controller: "admin/infos", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/infos/new").should route_to(controller: "admin/infos", action: "new")
    end

    it "routes to #create" do
      post("/admin/infos").should route_to(controller: "admin/infos", action: "create")
    end

    it "routes to #edit" do
      get("/admin/infos/5/edit").should route_to(controller: "admin/infos", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/infos/5").should route_to(controller: "admin/infos", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/infos/5").should route_to(controller: "admin/infos", action: "destroy", id: "5")
    end
  end
end
