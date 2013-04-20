require "spec_helper"

describe Api::GroupsController do
  describe "routing" do

    it "routes to #show" do
      get("/api/groups/show").should route_to(controller: "api/groups", action: "show")
    end

    it "routes to #list" do
      get("/api/groups/list").should route_to(controller: "api/groups", action: "list")
    end

    it "routes to #search" do
      get("/api/groups/search").should route_to(controller: "api/groups", action: "search")
    end

    it "routes to #create" do
      post("/api/groups/create").should route_to(controller: "api/groups", action: "create")
    end

    it "routes to #update" do
      post("/api/groups/update").should route_to(controller: "api/groups", action: "update")
    end
  end
end
