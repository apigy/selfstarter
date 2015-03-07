require 'spec_helper'

describe "payments/index" do
  before(:each) do
    assign(:payments, [
      stub_model(Payment,
        :card_number => "Card Number",
        :card_holder_name => "Card Holder Name",
        :card_expiration_month => "Card Expiration Month",
        :card_expiration_year => "Card Expiration Year",
        :card_cvv => "Card Cvv",
        :card_hash => "Card Hash",
        :payment_amount => "Payment Amount"
      ),
      stub_model(Payment,
        :card_number => "Card Number",
        :card_holder_name => "Card Holder Name",
        :card_expiration_month => "Card Expiration Month",
        :card_expiration_year => "Card Expiration Year",
        :card_cvv => "Card Cvv",
        :card_hash => "Card Hash",
        :payment_amount => "Payment Amount"
      )
    ])
  end

  it "renders a list of payments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Card Number".to_s, :count => 2
    assert_select "tr>td", :text => "Card Holder Name".to_s, :count => 2
    assert_select "tr>td", :text => "Card Expiration Month".to_s, :count => 2
    assert_select "tr>td", :text => "Card Expiration Year".to_s, :count => 2
    assert_select "tr>td", :text => "Card Cvv".to_s, :count => 2
    assert_select "tr>td", :text => "Card Hash".to_s, :count => 2
    assert_select "tr>td", :text => "Payment Amount".to_s, :count => 2
  end
end
