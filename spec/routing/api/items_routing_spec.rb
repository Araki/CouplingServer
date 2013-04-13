require "spec_helper"

describe Admin::ItemsController do
  describe "routing" do

    it "routes to #list" do
      get("/admin/items/list").should route_to(controller: "admin/items", action: "list")
    end
  end
end
