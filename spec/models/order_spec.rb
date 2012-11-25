describe Order do
  
    context "attributes" do
      
      [:address_one, :address_two, :city, :country, :number, :state, :status, 
        :token, :transaction_id, :zip, :shipping, :tracking_number, :name, 
        :price, :phone, :expiration
      ].each do |property|
          it { should allow_mass_assignment_of property }   
      end  

      it { should_not allow_mass_assignment_of :uuid }

      it "generates UUID before validation on_create" do
      end

      it { Order.primary_key.should == 'uuid' }

    end

    describe ".prefill!" do

      before do
        @options = {
          name: 'marin',
          user_id: 12983,
          price: 123.12
        }
        @order = Order.prefill!(@options)
      end

      it "sets the name" do
        @order.name.should eq @options[:name]
      end

      it "sets user_id" do
        @order.user_id.should eq @options[:user_id]
      end

      it "sets the price" do
        @order.price.should eq @options[:price]
      end

      it "saves" do
        Order.any_instance.should_receive :save!
        Order.prefill!(@options)
      end

      it "uses the right order number" do
        @order.number.should eq Order.next_order_number - 1
      end

    end

end