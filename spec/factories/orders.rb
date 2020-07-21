FactoryBot.define do
  factory :order do
    sequence(:recipient_name) { |n| "Recipient #{n}"  }
    bouquet
    shipping_option 
    order_type 
    state { Order.states.keys.sample } 
    first_delivery_date { (Time.now+rand(6.months.to_i)).to_date }

    trait :with_state_billed do 
      state { 'billed' } 
    end 
    trait :with_state_complete do 
      state { 'complete' } 
    end 
  end
end
