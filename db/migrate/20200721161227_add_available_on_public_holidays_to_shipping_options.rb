class AddAvailableOnPublicHolidaysToShippingOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :shipping_options, :available_on_public_holidays, :boolean, default: false 
  end
end
