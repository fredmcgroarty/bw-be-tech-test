class DeliveriesCreator

  def initialize(excluded_delivery_dates: nil, order:)
    raise(
      TypeError,
      "expected an Order, got #{order.class.name} instead."
    ) unless order.is_a?(Order)

    @excluded_delivery_dates = excluded_delivery_dates || []
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

  attr_reader :excluded_delivery_dates,
              :order

  def new_delivery(date:)
    order.deliveries.new(
      bouquet: order.bouquet,
      delivery_date: date,
      recipient_name: order.recipient_name,
      shipping_option: order.shipping_option
    )
  end

  def no_of_deliveries
    order.max_deliveries
  end

  def delivery_dates
    dates = [order.first_delivery_date]

    # doing it this way means if a delivery haa to be moved forward a
    # date because of shipping restrictions, then subsequent deliveries
    # aren't also adjusted to suit the 28 day interval.
    # The next delivery would be in 27 days time if the previous
    # delivery fell on a bank holiday.

    (no_of_deliveries - 1).times { dates << (dates[-1] + 28.days) }
    return dates if excluded_delivery_dates.empty?

    dates.map! { |date| find_available_date(date) }
  end

  def find_available_date(date)
    return date unless excluded_delivery_dates.include?(date)
    find_available_date(date + 1.day)
  end
end
