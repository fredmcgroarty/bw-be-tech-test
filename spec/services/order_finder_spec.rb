require 'rails_helper'

RSpec.describe OrderFinder do

  ORDERS_OVER_N_DAYS = 7
  
  describe '#initialize' do 
    it "sets billed as default state" do 
      order_finder = described_class.new(date: Date.today) 
      expect(order_finder.send(:state)).to eq :billed
    end 

    it 'blows if a delivery_date is not passed' do 
      expect { described_class.new }.to raise_error(ArgumentError)
    end 
  end 

  describe '#perform' do 

    context 'given a random number of billed orders over the next 7 days' do
      
      before do 
        delivery_date_buffer = ORDERS_OVER_N_DAYS + 3
        @delivery_date = Date.today + delivery_date_buffer.days  

        @orders = []
        ORDERS_OVER_N_DAYS.times do |i| 
          i = i + 1 
          @orders << create_list(
            :order, rand(2..5), :with_state_billed,
            first_delivery_date: Date.today + i.days
          )
        end
        @orders.flatten!
      end 

      it 'returns an ActiveRecordRelation' do 
        order_finder = described_class.new(
          date: @delivery_date
        )
        expect(order_finder.perform).to be_a(ActiveRecord::Relation)

      end 

      it 'when provided a date it returns the right orders' do
        order_finder = described_class.new(
          date: @delivery_date
        )

        order = create(:order, :with_state_billed, first_delivery_date: @delivery_date) 
        expect(order_finder.perform).to eq [order] 


        order_finder = described_class.new(
          date: Date.today + 2.days
        )

        results = order_finder.perform 
        expect(results).to be_many 
        expect(results).not_to include(order)

        order_finder = described_class.new(
          date: Date.today + 2.days,
          state: :complete 
        )
        expect(order_finder.perform).to be_empty 
      end 

    end 
  end 

end 
