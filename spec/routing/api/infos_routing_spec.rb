require "spec_helper"

describe Api::InfosController do
  describe "routing" do

    it "routes to #list" do
      get("/api/infos/list").should route_to(controller: "api/infos", action: "list")
    end
  end
end
