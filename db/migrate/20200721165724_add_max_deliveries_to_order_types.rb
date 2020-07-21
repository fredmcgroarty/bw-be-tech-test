class AddMaxDeliveriesToOrderTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :order_types, :max_deliveries, :integer
    change_column_null :order_types, :max_deliveries, false
  end
end
