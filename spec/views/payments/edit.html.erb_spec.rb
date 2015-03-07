require 'spec_helper'

describe "payments/edit" do
  before(:each) do
    @payment = assign(:payment, stub_model(Payment,
      :card_number => "MyString",
      :card_holder_name => "MyString",
      :card_expiration_month => "MyString",
      :card_expiration_year => "MyString",
      :card_cvv => "MyString",
      :card_hash => "MyString",
      :payment_amount => "MyString"
    ))
  end

  it "renders the edit payment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", payment_path(@payment), "post" do
      assert_select "input#payment_card_number[name=?]", "payment[card_number]"
      assert_select "input#payment_card_holder_name[name=?]", "payment[card_holder_name]"
      assert_select "input#payment_card_expiration_month[name=?]", "payment[card_expiration_month]"
      assert_select "input#payment_card_expiration_year[name=?]", "payment[card_expiration_year]"
      assert_select "input#payment_card_cvv[name=?]", "payment[card_cvv]"
      assert_select "input#payment_card_hash[name=?]", "payment[card_hash]"
      assert_select "input#payment_payment_amount[name=?]", "payment[payment_amount]"
    end
  end
end
