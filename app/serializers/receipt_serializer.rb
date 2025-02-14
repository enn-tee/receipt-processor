class ReceiptSerializer < ActiveModel::Serializer
  attributes :id, :retailer, :purchase_date, :purchase_time, :total
  has_many :items
end