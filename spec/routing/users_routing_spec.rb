require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #new" do
      get("/users/new").should route_to("users#new")
    end

    it "routes to #edit" do
      get("/users/1/edit").should route_to("users#edit", :id => "1")
    end

    it "routes to #register" do
      get("/users/register/1").should route_to("users#register", :uuid => "1")
    end

    it "routes to #create" do
      post("/users").should route_to("users#create")
    end

    it "routes to #update" do
      put("/users/1").should route_to("users#update", :id => "1")
    end

    it "routes to #update_for_register" do
      put("/users/update_for_register/1").should route_to("users#update_for_register", :id => "1")
    end

  end
end
