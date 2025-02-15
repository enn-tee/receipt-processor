FactoryBot.define do
  factory :receipt do
    retailer { "Some Company" }
    purchase_date { Date.current }
    purchase_time { Time.current }
    total { 12345 }

    after(:build) do |receipt|
      receipt.items << build(:item, receipt: receipt)
    end
  end
end
