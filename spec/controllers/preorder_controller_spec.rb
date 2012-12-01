describe PreorderController do

  before do
    @controller = PreorderController.new
    @params = { email: 'mneorr@gmail.com' }
    @controller.stub(:params).and_return(@params)
    @controller.stub(:request).and_return(stub( scheme: nil, host: 'mneorr.com'))
    @controller.stub(:redirect_to)
    Order.stub(:prefill!).and_return(stub(uuid: 1232131))
  end

  it { should respond_to :index, :checkout, :ipn }

  describe "#prefill" do
    
    it "finds user by email from params" do
      User.should_receive(:find_or_create_by_email!).with(@params[:email]).and_return(stub(id: 1))
      @controller.prefill
    end

    it "prefills the Order" do
      Order.should_receive(:prefill!).with( { name: Settings.product_name,
                                              price: Settings.price,
                                              user_id: 1 } )
      @controller.prefill
    end

  end
  
end