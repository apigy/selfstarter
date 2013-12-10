require 'spec_helper'

describe "Routing" do
  it "routes /admin to dashboard#show" do
    expect(:get => "/admin").to route_to(
      controller: "admin/dashboard", action: "show"
    )
  end
  it "routes /admin/dashboard to dashboard#show" do
    expect(:get => "/admin/dashboard").to route_to(
      controller: "admin/dashboard", action: "show"
    )
  end
end
