require "spec_helper"

describe Api::User::AccountController do
  describe "routing" do

    it "routes to #show_profile" do
      get("/api/account/show_profile").should route_to(controller: "api/user/account", action: "show_profile")
    end

    it "routes to #update_profile" do
      post("/api/account/update_profile").should route_to(controller: "api/user/account", action: "update_profile")
    end

    it "routes to #destroy" do
      post("/api/account/destroy").should route_to(controller: "api/user/account", action: "destroy")
    end
  end
end
