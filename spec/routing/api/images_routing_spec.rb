require "spec_helper"

describe Api::ImagesController do
  describe "routing" do

    it "routes to #list" do
      get("/api/images/list").should route_to(controller: "api/images", action: "list")
    end

    it "routes to #create" do
      post("/api/images/create").should route_to(controller: "api/images", action: "create")
    end

    it "routes to #destroy" do
      post("/api/images/5/destroy").should route_to(controller: "api/images", action: "destroy", id: "5")
    end

    it "routes to #set_main" do
      post("/api/images/5/set_main").should route_to(controller: "api/images", action: "set_main", id: "5")
    end
  end
end
