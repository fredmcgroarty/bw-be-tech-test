
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

    subject(:deliveries_creator) { described_class.new(order: @order).perform }  
    let(:first_delivery_date) { Date.tomorrow }

    it 'when all the deliveries save it returns an array' do 
      @order = create(:order) 
      expect(subject).to be_a Array
    end 
    
    it 'when one of deliveries fails it rollsback' do 
      @order = create(:order) 
      erroneous_delivery_dates = [Date.tomorrow, nil, Date.yesterday]
      allow_any_instance_of(described_class).to receive(:delivery_dates).and_return(erroneous_delivery_dates)

      expect(subject).to be_nil
      expect { subject }.to change(Delivery, :count).by(0)
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
        expect { subject }.to change(@order.deliveries, :count).by(1)
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
        expect { subject }.to change(@order.deliveries, :count).by(3)
      end 

      it 'ensures each delivery is 28 days apart' do 
        interval = 28.days 

        expected_delivery_dates = [
          first_delivery_date, 
          (first_delivery_date + interval),
          (first_delivery_date + (interval * 2))
        ]

        expect(subject.collect(&:delivery_date)).to eq expected_delivery_dates 
      end 
    end 
  end 
end 
