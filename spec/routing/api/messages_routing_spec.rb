require "spec_helper"

describe Api::MessagesController do
  describe "routing" do

    it "routes to #list" do
      get("/api/messages/list").should route_to(controller: "api/messages", action: "list")
    end

    it "routes to #create" do
      post("/api/messages/create").should route_to(controller: "api/messages", action: "create")
    end
  end
end
