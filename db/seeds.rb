Receipt.create!(
  retailer: 'Walgreens',
  purchase_date: Date.new(2022, 1, 2),
  purchase_time: Time.new(2022, 1, 2, 8, 13),
  total: 2.65,
  items_attributes: [
    {
      short_description: 'Pepsi - 12-oz',
      price: 1.25
    },
    {
      short_description: 'Dasani',
      price: 1.40
    }
  ]
)

Receipt.create!(
  retailer: 'Target',
  purchase_date: Date.new(2022, 1, 2),
  purchase_time: Time.new(2022, 1, 2, 13, 13),
  total: 1.25,
  items_attributes: [
    {
      short_description: 'Pepsi - 12-oz',
      price: 1.25
    }
  ]
)
