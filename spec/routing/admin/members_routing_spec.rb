require "spec_helper"

describe Admin::ProfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/profiles").should route_to(controller: "admin/profiles", action: "index")
    end

    it "routes to #show" do
      get("/admin/profiles/5").should route_to(controller: "admin/profiles", action: "show", id: "5")
    end
    
    it "routes to #edit" do
      get("/admin/profiles/5/edit").should route_to(controller: "admin/profiles", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/profiles/5").should route_to(controller: "admin/profiles", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/profiles/5").should route_to(controller: "admin/profiles", action: "destroy", id: "5")
    end
  end
end
