require 'spec_helper'

describe "payments/show" do
  before(:each) do
    @payment = assign(:payment, stub_model(Payment,
      :card_number => "Card Number",
      :card_holder_name => "Card Holder Name",
      :card_expiration_month => "Card Expiration Month",
      :card_expiration_year => "Card Expiration Year",
      :card_cvv => "Card Cvv",
      :card_hash => "Card Hash",
      :payment_amount => "Payment Amount"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Card Number/)
    rendered.should match(/Card Holder Name/)
    rendered.should match(/Card Expiration Month/)
    rendered.should match(/Card Expiration Year/)
    rendered.should match(/Card Cvv/)
    rendered.should match(/Card Hash/)
    rendered.should match(/Payment Amount/)
  end
end
