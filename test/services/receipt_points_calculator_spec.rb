require "rails_helper"

RSpec.describe ReceiptPointsCalculator do
  let(:item1) { create(:item, short_description: "Mountain Dew", price: 3.99) }
  let(:item2) { create(:item, short_description: "Bread", price: 2.49) }
  let(:receipt) do
    create(:receipt,
      retailer: "Target",
      total: 35.35,
      items: [ item1, item2 ],
      purchase_date: Time.zone.parse("2024-01-15"),
      purchase_time: Time.zone.parse("2024-01-15 14:30"))
  end

  subject(:calculator) { described_class.new(receipt) }

  describe "#calculate" do
    it "sums all point calculations" do
      expect(calculator.calculate).to eq(
        calculator.send(:retailer_name_points) +
          calculator.send(:round_dollar_points) +
          calculator.send(:quarter_multiple_points) +
          calculator.send(:items_pair_points) +
          calculator.send(:items_description_points) +
          calculator.send(:odd_day_points) +
          calculator.send(:time_of_day_points)
      )
    end
  end

  describe "retailer name points" do
    it "counts alphanumeric characters in retailer name" do
      expect(receipt).to receive(:retailer).and_return("Target!")
      expect(calculator.send(:retailer_name_points)).to eq(6)
    end

    it "ignores special characters and spaces" do
      expect(receipt).to receive(:retailer).and_return("Tar-get! Store")
      expect(calculator.send(:retailer_name_points)).to eq(11)
    end
  end

  describe "round dollar points" do
    it "awards 50 points for round dollar amounts" do
      expect(receipt).to receive(:total).and_return(100.00)
      expect(calculator.send(:round_dollar_points)).to eq(50)
    end

    it "awards 0 points for non-round dollar amounts" do
      expect(receipt).to receive(:total).and_return(100.01)
      expect(calculator.send(:round_dollar_points)).to eq(0)
    end
  end

  describe "quarter multiple points" do
    it "awards 25 points for amounts divisible by 0.25" do
      expect(receipt).to receive(:total).and_return(10.75)
      expect(calculator.send(:quarter_multiple_points)).to eq(25)
    end

    it "awards 0 points for amounts not divisible by 0.25" do
      expect(receipt).to receive(:total).and_return(10.99)
      expect(calculator.send(:quarter_multiple_points)).to eq(0)
    end
  end

  describe "items pair points" do
    it "awards 5 points for every two items" do
      expect(receipt).to receive(:items).and_return([ item1, item2, item1, item2 ])
      expect(calculator.send(:items_pair_points)).to eq(10)
    end

    it "ignores leftover items in odd-numbered lists" do
      expect(receipt).to receive(:items).and_return([ item1, item2, item1 ])
      expect(calculator.send(:items_pair_points)).to eq(5)
    end
  end

  describe "items description points" do
    context "when item description length is divisible by 3" do
      let(:item) { create(:item, short_description: "ABC   ", price: 3.99) }

      it "awards 20% of price (rounded up)" do
        expect(calculator.send(:calculate_item_description_points, item)).to eq(1)
      end
    end

    context "when item description length is not divisible by 3" do
      let(:item) { create(:item, short_description: "ABCD   ", price: 3.99) }

      it "awards 0 points" do
        expect(calculator.send(:calculate_item_description_points, item)).to eq(0)
      end
    end
  end

  describe "odd day points" do
    it "awards 6 points for odd numbered days" do
      expect(receipt).to receive(:purchase_date).and_return(Time.zone.parse("2024-01-15"))
      expect(calculator.send(:odd_day_points)).to eq(6)
    end

    it "awards 0 points for even numbered days" do
      expect(receipt).to receive(:purchase_date).and_return(Time.zone.parse("2024-01-16"))
      expect(calculator.send(:odd_day_points)).to eq(0)
    end
  end

  describe "time of day points" do
    it "awards 10 points for purchases between 2:00pm and 4:00pm" do
      expect(receipt).to receive(:time_in_hours_minutes_number).twice.and_return(1430)
      expect(calculator.send(:time_of_day_points)).to eq(10)
    end

    it "awards 0 points for purchases before 2:00pm" do
      expect(receipt).to receive(:time_in_hours_minutes_number).once.and_return(1359)
      expect(calculator.send(:time_of_day_points)).to eq(0)
    end

    it "awards 0 points for purchases at or after 4:00pm" do
      expect(receipt).to receive(:time_in_hours_minutes_number).twice.and_return(1600)
      expect(calculator.send(:time_of_day_points)).to eq(0)
    end
  end
end
