require "spec_helper"

describe Admin::CharactersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/characters").should route_to(controller: "admin/characters", action: "index")
    end

    it "routes to #show" do
      get("/admin/characters/5").should route_to(controller: "admin/characters", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/characters/new").should route_to(controller: "admin/characters", action: "new")
    end

    it "routes to #create" do
      post("/admin/characters").should route_to(controller: "admin/characters", action: "create")
    end

    it "routes to #edit" do
      get("/admin/characters/5/edit").should route_to(controller: "admin/characters", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/characters/5").should route_to(controller: "admin/characters", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/characters/5").should route_to(controller: "admin/characters", action: "destroy", id: "5")
    end
  end
end
