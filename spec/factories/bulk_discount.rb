FactoryBot.define do
  factory :bulk_discount do
    percentage { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    minimum_quantity { Faker::Number.within(range: 1..15) }
    merchant
  end
end
