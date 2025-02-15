FactoryBot.define do
  factory :item do
    short_description { Faker::Food.ingredient }
    price { 1234 }
    receipt
  end
end
