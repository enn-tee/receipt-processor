class ReceiptSerializer < ActiveModel::Serializer
  attributes :retailer, :purchase_date, :purchase_time, :total
  has_many :items
end
