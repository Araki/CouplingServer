require "spec_helper"

describe Api::LikesController do
  describe "routing" do

    it "routes to #create" do
      post("/api/likes/create").should route_to(controller: "api/likes", action: "create")
    end

    it "routes to #list" do
      get("/api/likes/list").should route_to(controller: "api/likes", action: "list")
    end
  end
end
