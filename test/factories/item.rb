FactoryBot.define do
  factory :item do
    short_description { Faker::Food.ingredient }
    price { Faker::Commerce.price }
    receipt
  end
end
