require "spec_helper"

describe Admin::ImagesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/images").should route_to(controller: "admin/images", action: "index")
    end

    it "routes to #show" do
      get("/admin/images/5").should route_to(controller: "admin/images", action: "show", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/images/5").should route_to(controller: "admin/images", action: "destroy", id: "5")
    end
  end
end
