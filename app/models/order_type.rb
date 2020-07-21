class OrderType < ApplicationRecord
  include Selectable

  validates :name, :max_deliveries, presence: true

  def to_s
    name
  end
end
