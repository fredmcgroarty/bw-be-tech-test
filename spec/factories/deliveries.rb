FactoryBot.define do
  factory :delivery do
    sequence(:recipient_name) { |n| "Recipient #{n}"  }
    bouquet
    shipping_option 
    order 
    delivery_date { Time.now + rand(1.year.to_i) }
  end
end
