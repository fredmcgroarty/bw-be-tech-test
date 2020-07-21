FactoryBot.define do
  factory :order_type do
    trait :single_delivery do
      name { 'Single delivery' }
      max_deliveries { 1 }
    end

    trait :three_month_bundle do
      name { '3 month bundle' }
      max_deliveries { 3 }
    end
  end
end
