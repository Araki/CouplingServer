require "spec_helper"

describe Admin::MessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/users/3/messages").should route_to(controller: "admin/messages", action: "index", user_id: "3")
    end

    it "routes to #destroy" do
      delete("/admin/users/3/messages/5").should route_to(controller: "admin/messages", action: "destroy", user_id: "3", id: "5")
    end
  end
end
