class Order < ApplicationRecord
  enum state: { billed: 'billed', complete: 'complete' }
  belongs_to :bouquet
  belongs_to :order_type
  belongs_to :shipping_option

  has_many :deliveries, dependent: :destroy

  validates :recipient_name, :bouquet_id, :order_type_id,
    :shipping_option_id, :first_delivery_date, presence: true

  delegate :max_deliveries, to: :order_type
end
