# 'Subdivision' felt like the most politically neutral term and non
# nation/constitution specific 
class UKPublicHolidayFetcher 
  
  class InvalidSubdivisionError < RuntimeError; end 

  FETCH_URL = 'https://www.gov.uk/bank-holidays.json'.freeze 
  SUBDIVISIONS = %w(england-and-wales 
                    northern-ireland 
                    scotland).freeze 

  attr_reader :list 

  def initialize(filter_past_dates: false, subdivision:)
    raise(
      InvalidSubdivisionError, 
      "Subdivison does not exist. \ 
      Valid subdivisions are: #{SUBDIVISIONS.join(', ')}." 
    ) unless SUBDIVISIONS.include?(subdivision.to_s)

    @filter_past_dates = filter_past_dates  
    @list = [] 
    @subdivision = subdivision 
  end

  def perform 
    @response ||= fetch

    response.dig(subdivision, :events).each do |event|   
      national_holiday = Date.parse(event[:date])
      
      next if filter_past_dates && (Date.today >= national_holiday) 
      
      list << national_holiday 
    end 
    list
  end 

  private 

  attr_reader :filter_past_dates, 
              :subdivision 
  attr_writer :response 
  
  def response 
    @response.with_indifferent_access 
  end 

  def fetch 
    HTTParty.get(FETCH_URL)
  end
end 
