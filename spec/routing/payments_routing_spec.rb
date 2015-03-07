require "spec_helper"

describe PaymentsController do
  describe "routing" do

    it "routes to #index" do
      get("/payments").should route_to("payments#index")
    end

    it "routes to #new" do
      get("/payments/new").should route_to("payments#new")
    end

    it "routes to #show" do
      get("/payments/1").should route_to("payments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/payments/1/edit").should route_to("payments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/payments").should route_to("payments#create")
    end

    it "routes to #update" do
      put("/payments/1").should route_to("payments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/payments/1").should route_to("payments#destroy", :id => "1")
    end

  end
end
