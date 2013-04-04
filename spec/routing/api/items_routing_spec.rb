require "spec_helper"

describe Api::ItemsController do
  describe "routing" do

    it "routes to #list" do
      get("/api/items/list").should route_to(controller: "api/items", action: "list")
    end

    it "routes to #purchase" do
      post("/api/items/purchase").should route_to(controller: "api/items", action: "purchase")
    end
  end
end
