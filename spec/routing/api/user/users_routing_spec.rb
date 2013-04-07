require "spec_helper"

describe Api::User::UsersController do
  describe "routing" do

    it "routes to #list" do
      get("/api/users/list").should route_to(controller: "api/user/users", action: "list")
    end

    it "routes to #show" do
      get("/api/users/5/show").should route_to(controller: "api/user/users", action: "show", :id => "5")
    end
  end
end
