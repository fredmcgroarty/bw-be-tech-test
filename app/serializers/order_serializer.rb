class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_delivery_date, :recipient_name, :state
  belongs_to :shipping_option 
  belongs_to :bouquet 
end
