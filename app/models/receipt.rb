class Receipt < ApplicationRecord
  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items

  before_validation :generate_external_id, on: :create

  validates :external_id, presence: true, uniqueness: true, format: {
    with: /\A\S+\z/, message: "can only contain non-whitespace characters"
  }
  validates :retailer, presence: true, format: {
    with: /\A[\w\s\-&]+\z/, message: "can only contain letters, numbers, spaces, hyphens, and ampersands"
  }
  validates :purchase_date, presence: true
  validates :purchase_time, presence: true
  validates :total_cents, presence: true, numericality: { only_integer: true }
  validates :items, presence: true

  validate :must_have_at_least_one_item
  validate :total_is_valid_number

  def total
    total_cents.to_f / 100 if total_cents
  end

  def total=(amount)
    if amount.present?
      # Check if amount is a valid decimal number
      if amount.to_s.match?(/\A\d+(\.\d{1,2})?\z/)
        self.total_cents = (amount.to_f * 100).round
      else
        self.total_cents = nil  # Force numericality validation to fail
      end
    end
  end

  def time_in_hours_minutes_number
    purchase_time.strftime("%H%M").to_i
  end

  private

  def must_have_at_least_one_item
    errors.add(:items, "must have at least one item") if items.empty?
  end

  def total_is_valid_number
    if total_cents.nil?
      errors.add(:total, "must be a valid number")
    end
  end

  def generate_external_id
    self.external_id ||= SecureRandom.uuid
  end
end
