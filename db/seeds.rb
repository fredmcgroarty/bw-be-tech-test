Bouquet.find_or_create_by!(name: "Harper", price: 35.00)
Bouquet.find_or_create_by!(name: "Alexa", price: 35.00)
Bouquet.find_or_create_by!(name: "Adrian", price: 40.00)

ShippingOption.find_or_create_by!(name: "Free shipping", price: 0, available_on_public_holidays: false)
ShippingOption.find_or_create_by!(name: "Premium shipping", price: 2.50, available_on_public_holidays: true)

OrderType.find_or_create_by!(name: "Single delivery", max_deliveries: 1)
OrderType.find_or_create_by!(name: "3 month bundle", max_deliveries: 3)
