require "spec_helper"

describe Admin::MatchesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/users/3/matches").should route_to(controller: "admin/matches", action: "index", user_id: "3")
    end

    it "routes to #destroy" do
      delete("/admin/users/3/matches/5").should route_to(controller: "admin/matches", action: "destroy", user_id: "3", id: "5")
    end
  end
end
