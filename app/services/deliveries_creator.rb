class DeliveriesCreator 
  
  def initialize(order:)
    raise(
      TypeError, "expected an Order, got #{order.class.name} instead."
    ) unless order.is_a?(Order)

    @order = order 
  end

  def perform 
    Delivery.transaction do 
      delivery_dates.map do |date| 
        delivery = new_delivery(date: date) 
        delivery.save ? delivery : raise(ActiveRecord::Rollback) 
      end 
    end 
  end 

  private 

  attr_reader :order
  
  def new_delivery(date:)
    order.deliveries.new(
      bouquet: order.bouquet,
      delivery_date: date,
      recipient_name: order.recipient_name,
      shipping_option: order.shipping_option
    )
  end 

  def no_of_deliveries 
    order.order_type.max_deliveries 
  end

  def delivery_dates 
    dates = [order.first_delivery_date] 
    
    (no_of_deliveries - 1).times do 
      dates << (dates[-1] + 28.days)
    end 

    dates   
  end 
end
