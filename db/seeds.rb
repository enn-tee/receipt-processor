Receipt.create!(
  external_id: 'ce4d1960-f838-424c-896b-e8e426dba1d7',
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
  external_id: '2f160ce8-e496-4ee0-bd23-2982f7534b1e',
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
