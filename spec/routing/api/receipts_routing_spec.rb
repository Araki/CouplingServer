require "spec_helper"

describe Api::ReceiptsController do
  describe "routing" do

    it "routes to #list" do
      get("/api/receipts/list").should route_to(controller: "api/receipts", action: "list")
    end

    it "routes to #validate" do
      post("/api/receipts/validate").should route_to(controller: "api/receipts", action: "validate")
    end
  end
end