require "rails_helper"

RSpec.describe ReceiptsController, type: :controller do
  describe "GET #show" do
    context "when receipt exists" do
      let(:receipt) { create(:receipt) }

      it "returns the receipt with items" do
        get :show, params: { id: receipt.external_id }

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["external_id"]).to eq(receipt.external_id)
        expect(parsed_response["items"]).to be_present
      end
    end

    context "when receipt does not exist" do
      it "returns 404" do
        get :show, params: { id: "non-existent-id" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # TODO: Fix tests below here and Linting

  describe 'GET #points' do
    context 'when receipt exists' do
      let(:receipt) { create(:receipt) }
      let(:calculator) { instance_double(ReceiptPointsCalculator) }

      before do
        allow(ReceiptPointsCalculator).to receive(:new).with(receipt).and_return(calculator)
        allow(calculator).to receive(:calculate).and_return(50)
      end

      it 'returns calculated points' do
        get :points, params: { id: receipt.external_id }

        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['points']).to eq(50)
      end
    end

    context 'when receipt does not exist' do
      it 'returns 404' do
        get :points, params: { id: 'non-existent-id' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        retailer: "Target",
        purchase_date: "2024-01-01",
        purchase_time: "14:33",
        total: "35.35",
        items: [
          { short_description: "Mountain Dew 12PK", price: "6.49" },
          { short_description: "Emils Pizza", price: "12.25" }
        ]
      }
    end

    context 'with valid parameters' do
      it 'creates a new receipt' do
        expect {
          post :create, params: valid_params
        }.to change(Receipt, :count).by(1)
      end

      it 'creates associated items' do
        expect {
          post :create, params: valid_params
        }.to change(Item, :count).by(2)
      end

      it 'returns successful response with external_id' do
        post :create, params: valid_params

        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to be_present

        created_receipt = Receipt.find_by(external_id: parsed_response['id'])
        expect(created_receipt).to be_present
        expect(created_receipt.items.count).to eq(2)
      end

      it 'properly sets receipt attributes' do
        post :create, params: valid_params

        receipt = Receipt.last
        expect(receipt.retailer).to eq("Target")
        expect(receipt.purchase_date.to_s).to eq("2024-01-01")
        expect(receipt.purchase_time.strftime("%H:%M")).to eq("14:33")
        expect(receipt.total).to eq(35.35)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        valid_params.tap { |params| params[:retailer] = "Invalid@Retailer" }
      end

      it 'does not create a receipt' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Receipt, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to be_present
      end
    end

    context 'with missing required parameters' do
      let(:incomplete_params) do
        valid_params.except(:retailer)
      end

      it 'returns unprocessable entity status' do
        post :create, params: incomplete_params

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to have_key('retailer')
      end
    end

    context 'with invalid items' do
      let(:params_with_invalid_items) do
        valid_params.tap do |params|
          params[:items] = [
            { short_description: "Invalid@Item", price: "6.49" }
          ]
        end
      end

      it 'returns unprocessable entity status' do
        post :create, params: params_with_invalid_items

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to have_key('items.short_description')
      end
    end
  end
end
