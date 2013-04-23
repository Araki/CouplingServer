require "spec_helper"

describe Admin::HobbiesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/hobbies").should route_to(controller: "admin/hobbies", action: "index")
    end

    it "routes to #show" do
      get("/admin/hobbies/5").should route_to(controller: "admin/hobbies", action: "show", id: "5")
    end

    it "routes to #new" do
      get("/admin/hobbies/new").should route_to(controller: "admin/hobbies", action: "new")
    end

    it "routes to #create" do
      post("/admin/hobbies").should route_to(controller: "admin/hobbies", action: "create")
    end

    it "routes to #edit" do
      get("/admin/hobbies/5/edit").should route_to(controller: "admin/hobbies", action: "edit", id: "5")
    end

    it "routes to #update" do
      put("/admin/hobbies/5").should route_to(controller: "admin/hobbies", action: "update", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/hobbies/5").should route_to(controller: "admin/hobbies", action: "destroy", id: "5")
    end
  end
end
