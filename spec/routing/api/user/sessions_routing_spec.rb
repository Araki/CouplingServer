require "spec_helper"

describe Api::User::SessionsController do
  describe "routing" do

    it "routes to #create" do
      post("/api/sessions/create").should route_to(controller: "api/user/sessions", action: "create")
    end

    it "routes to #verify" do
      get("/api/sessions/verify").should route_to(controller: "api/user/sessions", action: "verify")
    end

    it "routes to #destroy" do
      post("/api/sessions/destroy").should route_to(controller: "api/user/sessions", action: "destroy")
    end
  end
end
