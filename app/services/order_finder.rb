class OrderFinder 
  
  def initialize(state: :billed, 
                 date:)
    @date = date 
    @state = state
  end

  def perform 
    Order.where(
      state: state.to_s,
      first_delivery_date: date
    )
  end 

  private 

  attr_reader :date, :state
end
