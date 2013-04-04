require "spec_helper"

describe Api::MatchesController do
  describe "routing" do

    it "routes to #list" do
      get("/api/matches/list").should route_to(controller: "api/matches", action: "list")
    end
  end
end
