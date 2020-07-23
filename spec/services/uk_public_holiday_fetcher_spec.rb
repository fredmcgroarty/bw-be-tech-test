require 'rails_helper'

RSpec.describe UKPublicHolidayFetcher do
  
  def random_subdivision  
    described_class::SUBDIVISIONS.sample 
  end 

  describe '#initialize' do 
    
    it 'raises an error given a non listed SUBDIVISION' do 
      expect { described_class.new(subdivision: 'yorkshire') }.to raise_error(UKPublicHolidayFetcher::InvalidSubdivisionError)
    end 

    it 'accepts anything included in SUBDIVISIONS' do 
      described_class::SUBDIVISIONS.each do |sd|
        expect { described_class.new(subdivision: sd) }.not_to raise_error 
      end 
    end 

    it 'initialized with #list as an empty array' do 
      instance = described_class.new(subdivision: random_subdivision)
      expect(instance.list).to be_empty 
    end 

    it 'sets #filter_past_dates to false by default' do 
      instance = described_class.new(subdivision: random_subdivision)
      expect(instance.send(:filter_past_dates)).to eq false
    end 
  end 


  describe '#perform' do 

    it 'populates the list with Date' do 
      instance = described_class.new(subdivision: random_subdivision)

      instance.perform 

      expect(instance.list).to be_many
      expect(instance.list[-1]).to be_a Date
    end 


    context 'when filter_past_dates is enabled' do 
      it 'filters out dates before today' do 
        instance = described_class.new(subdivision: random_subdivision, filter_past_dates: true)

      list = instance.perform 

       expect(
        list.find { |a| a <= Date.today }
       ).to be_nil

       expect(
         list.find { |a| a >= Date.today }
       ).to be_a(Date)
      end 
    end 
  end 
end 
