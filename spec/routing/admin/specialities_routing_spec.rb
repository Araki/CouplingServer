require "spec_helper"

describe Admin::SpecialitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/specialities").should route_to(controller: "admin/specialities", action: "index")
    end

    it "routes to #show" do
      get("/admin/specialities/5").should route_to(controller: "admin/specialities", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/specialities/new").should route_to(controller: "admin/specialities", action: "new")
    end

    it "routes to #create" do
      post("/admin/specialities").should route_to(controller: "admin/specialities", action: "create")
    end

    it "routes to #edit" do
      get("/admin/specialities/5/edit").should route_to(controller: "admin/specialities", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/specialities/5").should route_to(controller: "admin/specialities", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/specialities/5").should route_to(controller: "admin/specialities", action: "destroy", id: "5")
    end
  end
end
