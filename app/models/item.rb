class Item < ApplicationRecord
  belongs_to :receipt

  validates :short_description, presence: true,
            format: { with: /\A[\w\s\-]+\z/, message: "can only contain letters, numbers, spaces, and hyphens" }
  validates :price_cents, presence: true, numericality: { only_integer: true }

  def price
    price_cents.to_f / 100 if price_cents
  end

  def price=(amount)
    self.price_cents = (amount.to_f * 100).round if amount.present?
  end
end
