describe PreorderController do

  before do
    @controller = PreorderController.new
    @params = { email: 'mneorr@gmail.com' }
    @controller.stub(:params).and_return(@params)

    @controller.stub(:request).and_return(stub( scheme: nil, host: 'mneorr.com'))
    @controller.stub(:redirect_to)
  end

  it { should respond_to :index, :checkout, :ipn }

  describe "#prefill" do
    
    before do
      @controller.prefill
    end

    it "finds user by email from params" do
      @controller.instance_variable_get(:@user).email.should == "mneorr@gmail.com"
    end

    it "prefills the Order" do
      order = @controller.instance_variable_get(:@order)
      order.name.should == Settings.product_name
      order.price.should == Settings.price
      order.user_id.should == 1
    end

  end
  
end