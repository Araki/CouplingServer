require "spec_helper"

describe Admin::SessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/sessions").should route_to(controller: "admin/sessions", action: "index")
    end

    it "routes to #show" do
      get("/admin/sessions/5").should route_to(controller: "admin/sessions", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/sessions/new").should route_to(controller: "admin/sessions", action: "new")
    end

    it "routes to #create" do
      post("/admin/sessions").should route_to(controller: "admin/sessions", action: "create")
    end
    
    it "routes to #edit" do
      get("/admin/sessions/5/edit").should route_to(controller: "admin/sessions", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/sessions/5").should route_to(controller: "admin/sessions", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/sessions/5").should route_to(controller: "admin/sessions", action: "destroy", id: "5")
    end
  end
end
