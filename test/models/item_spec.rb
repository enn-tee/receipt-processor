require "rails_helper"

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should belong_to(:receipt) }
  end

  describe "validations" do
    subject { build(:item) }

    it { should validate_presence_of(:short_description) }
    it { should validate_presence_of(:price_cents) }
    it { should validate_numericality_of(:price_cents).only_integer }

    context "short_description format" do
      it "allows valid descriptions" do
        valid_descriptions = [
          "Milk 2",
          "Organic Bananas",
          "Paper-Towels",
          "Diet Coke 12 Pack"
        ]

        valid_descriptions.each do |description|
          item = build(:item, short_description: description)
          expect(item).to be_valid
        end
      end

      it "rejects invalid descriptions" do
        invalid_descriptions = [
          "Milk@2%",
          "Bananas!",
          "Paper&Towels",
          "Coke (12 Pack)"
        ]

        invalid_descriptions.each do |description|
          item = build(:item, short_description: description)
          expect(item).not_to be_valid
          expect(item.errors[:short_description]).to include(
            "can only contain letters, numbers, spaces, and hyphens"
          )
        end
      end
    end
  end

  describe "#price" do
    it "converts cents to dollars" do
      item = build(:item, price_cents: 1099)
      expect(item.price).to eq(10.99)
    end

    it "returns nil when price_cents is nil" do
      item = build(:item, price_cents: nil)
      expect(item.price).to be_nil
    end

    it "handles zero correctly" do
      item = build(:item, price_cents: 0)
      expect(item.price).to eq(0.0)
    end
  end

  describe "#price=" do
    it "converts dollars to cents" do
      item = build(:item, price: 10.99)
      expect(item.price_cents).to eq(1099)
    end

    it "handles string input" do
      item = build(:item, price: "10.99")
      expect(item.price_cents).to eq(1099)
    end

    it "rounds to nearest cent" do
      item = build(:item, price: 10.999)
      expect(item.price_cents).to eq(1100)
    end

    it "handles zero correctly" do
      item = build(:item, price: 0)
      expect(item.price_cents).to eq(0)
    end

    it "sets nil when input is blank" do
      item = build(:item, price_cents: nil)
      item.price = ""
      expect(item.price_cents).to be_nil
    end
  end
end
