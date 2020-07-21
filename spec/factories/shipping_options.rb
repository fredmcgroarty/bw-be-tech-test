FactoryBot.define do
  factory :shipping_option do
    sequence(:name) { |n| "shipping option name #{n}" }
    price { [0, 2.5].sample } 
    trait :free do
      name { 'Free shipping' }
      price { 0 }
      available_on_public_holidays { false } 
    end

    trait :premium do
      name { 'Premium shipping' }
      price { 2.50 }
      available_on_public_holidays { true } 
    end
  end
end
