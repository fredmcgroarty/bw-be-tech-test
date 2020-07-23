class OrderCompleter 

  def initialize(order)
    @order = order  
  end

  def perform 
    if complete?
      order.complete!
      # send email, whatever else
    else 
      false
    end 
  end

  private 

  attr_reader :order

  def complete?
    order.deliveries.count == order.max_deliveries 
  end 
end
