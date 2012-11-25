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

end