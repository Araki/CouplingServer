require "spec_helper"

describe Admin::ReceiptsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/receipts").should route_to(controller: "admin/receipts", action: "index")
    end

    it "routes to #show" do
      get("/admin/receipts/5").should route_to(controller: "admin/receipts", action: "show", id: "5")
    end

    it "routes to #destroy" do
      delete("/admin/receipts/5").should route_to(controller: "admin/receipts", action: "destroy", id: "5")
    end
  end
end
