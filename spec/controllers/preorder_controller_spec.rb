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
      pipeline = assigns(:pipeline)
      order = assigns(:order)

      pipeline.caller_reference.should == order.uuid
      pipeline.transaction_amount.should == order.price
      pipeline.global_amount_limit.should == Settings.charge_limit
      pipeline.collect_shipping_address.should == "True"
      pipeline.payment_reason.should == Settings.payment_description
    end

    it "redirects to pipeline url" do
      url = assigns(:pipeline).url("#{request.scheme}://#{request.host}/preorder/postfill")
      response.should redirect_to(url)
    end

  end

  describe "#postfill" do
    fixtures :orders
    
    before do
      @uuid = 'ec781fa2-c5e6-4af9-8049-4dee15a85296'
      Order.stub(:postfill!).and_return orders(:one)
    end

    it "checks for the caller refernece existance" do
      expect { get :postfill 
               assigns(:order).should be_nil }.to_not raise_error
      
    end

    it "postfills the order" do
      get :postfill, callerReference: @uuid
      assigns(:order).uuid.should == @uuid
    end

    it "redirects to root_url if user cancelled the preorder before clicking 'Confirm' on Amazon Payments" do
      get :postfill, callerReference: @uuid, status: 'A'
      response.should redirect_to root_url
    end

    it "redirects to root url if order is not present" do
      Order.should_receive(:postfill!).and_return nil
      get :postfill, callerReference: @uuid, status: 'B'
      response.should redirect_to root_url
    end

    it "redirects to #share if everything's ok" do
      get :postfill, callerReference: @uuid, status: 'B'
      response.should redirect_to action: 'share', uuid: assigns(:order).uuid
    end

  end

  describe "#share" do

    it "finds the order by uuid" do
      get :share, uuid: 12321
      assigns(:order).user_id.should == '2'
    end
    
  end
  
end