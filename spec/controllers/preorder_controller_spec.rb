describe PreorderController do

  it { should respond_to :index, :checkout, :ipn }

  [:index, :checkout].each do |method|
    it "should get #{method}" do
      get method
      response.should be_success
    end
  end

  describe "#prefill" do
    
    before do
      get :prefill, email: 'mneorr@gmail.com'
    end

    it "finds user by email from params" do
      assigns(:user).email.should == "mneorr@gmail.com"
    end

    it "prefills the Order" do
      order = assigns(:order)
      order.name.should == Settings.product_name
      order.price.should == Settings.price
      order.user_id.should == 1
    end

    it "sets up the amazon pipeline" do
      # TODO
    end

    it "redirects to pipeline url" do
      # TODO
    end

  end

  describe "#share" do

    it "finds the order by uuid" do
      get :share, uuid: 12321
      assigns(:order).user_id.should == '2'
    end
    
  end
  
end