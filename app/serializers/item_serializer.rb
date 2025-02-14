class ItemSerializer < ActiveModel::Serializer
  attributes :id, :short_description, :price
end