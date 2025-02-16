class ReceiptPointsCalculator
  attr_reader :receipt

  TWO_PM = 1400
  FOUR_PM = 1600

  def initialize(receipt)
    @receipt = receipt
  end

  def calculate
    total_points
  end

  private

  def total_points
    [
      retailer_name_points,
      round_dollar_points,
      quarter_multiple_points,
      items_pair_points,
      items_description_points,
      odd_day_points,
      time_of_day_points
    ].sum
  end

  def retailer_name_points
    receipt.retailer.scan(/[a-zA-Z0-9]/).count
  end

  def round_dollar_points
    (receipt.total % 1).zero? ? 50 : 0
  end

  def quarter_multiple_points
    (receipt.total % 0.25).zero? ? 25 : 0
  end

  def items_pair_points
    (receipt.items.count / 2) * 5
  end

  def items_description_points
    receipt.items.sum { |item| calculate_item_description_points(item) }
  end

  def calculate_item_description_points(item)
    return 0 unless (item.short_description.strip.length % 3).zero?

    (item.price * 0.2).ceil
  end

  def odd_day_points
    receipt.purchase_date.day.odd? ? 6 : 0
  end

  def time_of_day_points
    receipt.time_in_hours_minutes_number > TWO_PM && receipt.time_in_hours_minutes_number < FOUR_PM ? 10 : 0
  end
end
