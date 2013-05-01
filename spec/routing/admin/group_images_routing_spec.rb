require "spec_helper"

describe Admin::GroupImagesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/group_images").should route_to(controller: "admin/group_images", action: "index")
    end

    it "routes to #show" do
      get("/admin/group_images/5").should route_to(controller: "admin/group_images", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/group_images/new").should route_to(controller: "admin/group_images", action: "new")
    end

    it "routes to #create" do
      post("/admin/group_images").should route_to(controller: "admin/group_images", action: "create")
    end

    it "routes to #edit" do
      get("/admin/group_images/5/edit").should route_to(controller: "admin/group_images", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/group_images/5").should route_to(controller: "admin/group_images", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/group_images/5").should route_to(controller: "admin/group_images", action: "destroy", id: "5")
    end
  end
end
