require "spec_helper"

describe Api::PointsController do
  describe "routing" do

    it "routes to #add" do
      post("/api/points/add").should route_to(controller: "api/points", action: "add")
    end

    it "routes to #consume" do
      post("/api/points/consume").should route_to(controller: "api/points", action: "consume")
    end
  end
end
