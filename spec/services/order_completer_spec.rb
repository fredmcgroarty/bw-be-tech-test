
require 'rails_helper'

RSpec.describe OrderCompleter do
  describe '#perform' do 

    subject(:deliveries_creator) { described_class.new(@order).perform }  
    let(:first_delivery_date) { Date.tomorrow }

    it 'returns false if the order is already complete' do 
      @order = create(:order, :complete) 

      expect(subject).to eq false
    end 
    
    it 'returns false if the order deliveries is NOT equal to max_deliveries on the assoicated order_type' do 
      order_type = create(:order_type, :three_month_bundle)
      @order = create(:order, :complete, order_type: order_type) 

      deliveries = create_list(:delivery, 2, order: @order)
      
      expect(subject).to eq false
    end 

    it 'returns true if the order deliveries is equal to max_deliveries on the assoicated order_type' do 
      order_type = create(:order_type, :three_month_bundle)
      @order = create(:order, :complete, order_type: order_type) 
      
      deliveries = create_list(:delivery, 3, order: @order)
      
      expect(subject).to eq true
    end 
  end 
end 
