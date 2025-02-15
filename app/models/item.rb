class Item < ApplicationRecord
  belongs_to :receipt

  validates :short_description, presence: true,
            format: { with: /\A[\w\s\-]+\z/, message: "can only contain letters, numbers, spaces, and hyphens" }
  validates :price_cents, presence: true, numericality: { only_integer: true }

  validate :price_is_valid_number

  def price
    price_cents.to_f / 100 if price_cents
  end

  def price=(amount)
    if amount.present?
      # Check if amount is a valid decimal number
      if amount.to_s.match?(/\A\d+(\.\d{1,2})?\z/)
        self.price_cents = (amount.to_f * 100).round
      else
        self.price_cents = nil  # Force numericality validation to fail
      end
    end
  end

  private

  def price_is_valid_number
    if price_cents.nil?
      errors.add(:price, "must be a valid number")
    end
  end
end
