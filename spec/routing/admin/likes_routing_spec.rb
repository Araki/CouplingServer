require "spec_helper"

describe Admin::LikesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/users/3/likes").should route_to(controller: "admin/likes", action: "index", user_id: "3")
    end

    it "routes to #destroy" do
      delete("/admin/users/3/likes/5").should route_to(controller: "admin/likes", action: "destroy", user_id: "3", id: "5")
    end
  end
end
