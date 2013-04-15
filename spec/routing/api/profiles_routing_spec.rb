require "spec_helper"

describe Api::ProfilesController do
  describe "routing" do

    it "routes to #list" do
      get("/api/profiles/list").should route_to(controller: "api/profiles", action: "list")
    end

    it "routes to #show" do
      get("/api/profiles/5/show").should route_to(controller: "api/profiles", action: "show", id: "5")
    end
  end
end
