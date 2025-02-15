require "rails_helper"

RSpec.describe Receipt, type: :model do
  describe "associations" do
    it { should have_many(:items).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:receipt) }

    context "external_id presence" do
      it "is valid with an external_id" do
        receipt = build(:receipt)
        expect(receipt).to be_valid
      end

      # Skip the callback to test the actual presence validation
      it "is invalid without an external_id" do
        receipt = build(:receipt)
        receipt.external_id = nil
        allow(receipt).to receive(:generate_external_id)  # Prevent callback from running
        expect(receipt).not_to be_valid
        expect(receipt.errors[:external_id]).to include("can't be blank")
      end
    end

    it { should validate_uniqueness_of(:external_id) }
    it { should validate_presence_of(:retailer) }
    it { should validate_presence_of(:purchase_date) }
    it { should validate_presence_of(:purchase_time) }
    it { should validate_presence_of(:total_cents) }
    it { should validate_numericality_of(:total_cents).only_integer }
    it { should validate_presence_of(:items) }

    context "external_id format" do
      it "allows valid external_ids" do
        receipt = build(:receipt, external_id: "valid-id-123")
        expect(receipt).to be_valid
      end
  
      it "rejects external_ids with whitespace" do
        receipt = build(:receipt, external_id: "invalid id")
        expect(receipt).not_to be_valid
        expect(receipt.errors[:external_id]).to include("can only contain non-whitespace characters")
      end
    end
  
    context "retailer format" do
      it "allows valid retailer names" do
        valid_names = %w[ Walmart Target-Store H&M Best Buy 123 ]
        valid_names.each do |name|
          receipt = build(:receipt, retailer: name)
          expect(receipt).to be_valid
        end
      end
  
      it "rejects invalid retailer names" do
        invalid_names = %w[ Store! Retail@Shop Store$123 ]
        invalid_names.each do |name|
          receipt = build(:receipt, retailer: name)
          expect(receipt).not_to be_valid
          expect(receipt.errors[:retailer]).to include("can only contain letters, numbers, " \
                                                       "spaces, hyphens, and ampersands")
        end
      end
    end
  end

  describe "callbacks" do
    context "before_validation on create" do
      it "generates an external_id if not present" do
        receipt = build(:receipt, external_id: nil)
        receipt.valid?
        expect(receipt.external_id).not_to be_nil
      end

      it "does not override existing external_id" do
        existing_id = SecureRandom.uuid
        receipt = build(:receipt, external_id: existing_id)
        receipt.valid?
        expect(receipt.external_id).to eq(existing_id)
      end
    end
  end

  describe "custom validations" do
    it "requires at least one item" do
      receipt = build(:receipt)
      receipt.items = []
      expect(receipt).not_to be_valid
      expect(receipt.errors[:items]).to include("must have at least one item")
    end
  end

  describe "#total" do
    it "converts cents to dollars" do
      receipt = build(:receipt, total_cents: 1234)
      expect(receipt.total).to eq(12.34)
    end

    it "returns nil when total_cents is nil" do
      receipt = build(:receipt, total_cents: nil)
      expect(receipt.total).to be_nil
    end
  end

  describe "#total=" do
    it "converts dollars to cents" do
      receipt = build(:receipt)
      receipt.total = 12.34
      expect(receipt.total_cents).to eq(1234)
    end

    it "handles string input" do
      receipt = build(:receipt)
      receipt.total = "12.34"
      expect(receipt.total_cents).to eq(1234)
    end

    it "rounds to nearest cent" do
      receipt = build(:receipt)
      receipt.total = 12.345
      expect(receipt.total_cents).to eq(1235)
    end

    it "sets nil when input is blank" do
      receipt = build(:receipt, total_cents: "")
      receipt.total = ""
      expect(receipt.total_cents).to be_nil
    end
  end
end
