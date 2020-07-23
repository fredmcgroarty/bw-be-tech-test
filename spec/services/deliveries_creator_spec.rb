require 'rails_helper'

RSpec.describe DeliveriesCreator do
  describe '#initialize' do 
    it 'type checks for Order' do
      order_type = create(:order_type) 
      expect { described_class.new(order: order_type) }.to raise_error TypeError 

      order = create(:order) 
      expect { described_class.new(order: order) }.not_to raise_error  
    end 
  end 

  describe '#perform' do 

    subject(:deliveries_creator) { described_class.new(order: @order, excluded_delivery_dates: @excluded_delivery_dates) }  
    let(:first_delivery_date) { Date.tomorrow }

    it 'when all the deliveries save it returns an array' do 
      @order = create(:order) 
      expect(subject.perform).to be_a Array
    end 
    
    context 'when a delivery fails to save' do 
      
      before do 
        @order = create(:order) 
      end 

      it 'reverses the entire transaction' do 
        erroneous_delivery_dates = [Date.tomorrow, nil, Date.yesterday]
        expect(subject).to receive(:delivery_dates).and_return(erroneous_delivery_dates)
        expect { subject.perform }.to change(Delivery, :count).by(0)
      end 

      it 'returns nil' do 
        expect_any_instance_of(Delivery).to receive(:save).and_return false
        expect(subject.perform).to be_nil
      end

    end 

    context 'given an order with a order type of single_delivery' do 
      before do 
        order_type_single_delivery = create(:order_type, :single_delivery)
        @order = create(:order, 
          first_delivery_date: first_delivery_date,
          order_type: order_type_single_delivery
        ) 
      end 

      it 'creates one delivery' do 
        expect { subject.perform }.to change(@order.deliveries, :count).by(1)
      end 
    end 
    
    context 'given a shipping_option of free and a delivery_date on a filtered date' do
      before do 
        # two exclusion days in a row to see if it handles it. 
        @excluded_delivery_dates = [Date.tomorrow, 
                                    (Date.tomorrow + 1.day),
                                    (Date.tomorrow + 3.days)]
        shipping_option = create(:shipping_option, :free)
        @order = create(:order, first_delivery_date: @excluded_delivery_dates[0], 
                                shipping_option: shipping_option)
      end 

      it 'moves the delivery to the next available date' do 
        deliveries = subject.perform
        expect(deliveries[0].delivery_date).to eq(Date.tomorrow + 2.day)
      end 
    end 

    context 'given an order with a order type of three_month_bundle' do 
      before do 
        order_type_three_month_bundle = create(:order_type, :three_month_bundle)
        @order = create(:order,
          first_delivery_date: first_delivery_date,
          order_type: order_type_three_month_bundle
        )
      end 

      it 'creates three deliveries' do 
        expect { subject.perform }.to change(@order.deliveries, :count).by(3)
      end 

      it 'ensures each delivery is 28 days apart' do 
        interval = 28.days 

        expected_delivery_dates = [
          first_delivery_date, 
          (first_delivery_date + interval),
          (first_delivery_date + (interval * 2))
        ]
        
        expect(subject.perform.collect(&:delivery_date)).to eq expected_delivery_dates 
      end 
    end 
  end 
end 
