require 'spec_helper'

describe Admin::DashboardController do

  render_views

  context "Authentication" do
    it "should return a 401 page if user logins with no credentials" do
      get 'show'
      expect(response.status).to eq(401)
    end
    it "should return a 401 page if user logins with invalid credentials" do
      http_login("shipwrecked", "")
      get 'show'
      expect(response.status).to eq(401)
    end
    it "should return http success if user logins with valid credentials" do
      http_login
      get 'show'
      expect(response).to be_success
    end
    it "should render show template if user logins with valid credentials" do
      http_login
      get 'show'
      expect(response).to render_template("show")
    end
  end

  context "#show" do
    it "should assigns all existing orders to @orders" do
      @user = User.create(email: "shipwrecked@lighthouselabs.ca")
      @order = @user.orders.create(name: "Order 1", price: 100)
      http_login
      get 'show'
      expect(assigns[:orders]).to eq([@order])
    end
  end
end
