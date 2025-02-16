class ReceiptsController < ApplicationController
  # TODO: Authorization
  wrap_parameters false

  def show
    @receipt = Receipt.find_by!(external_id: params[:id])
    render json: @receipt, include: :items
  end

  def points
    @receipt = Receipt.find_by!(external_id: params[:id])
    calculated = ReceiptPointsCalculator.new(@receipt).calculate
    render json: { points: calculated }
  end

  def create
    @receipt = Receipt.new(normalized_receipt_params)

    if @receipt.save
      render json: { id: @receipt.external_id }, status: :created
    else
      render json: { description: "The receipt is invalid." }, status: :bad_request
    end
  end

  private

  def normalized_receipt_params
    {
      retailer: raw_params[:retailer],
      purchase_date: raw_params[:purchase_date],
      purchase_time: raw_params[:purchase_time],
      total: raw_params[:total],
      items_attributes: raw_params[:items].map do |item|
        {
          short_description: item[:short_description],
          price: item[:price]
        }
      end
    }
  end

  def raw_params
    params.permit(
      :retailer,
      :purchase_date,
      :purchase_time,
      :total,
      items: [ :short_description, :price ]
    ).tap do |permitted_params|
      # Validate required parameters are present
      [ :retailer, :purchase_date, :purchase_time, :total, :items ].each do |key|
        if !permitted_params.key?(key) || permitted_params[key].nil?
          raise ActionController::ParameterMissing.new(key)
        end
      end

      # Validate each item has required fields
      permitted_params[:items].each do |item|
        [ :short_description, :price ].each do |item_key|
          if !item.key?(item_key) || item[item_key].nil?
            raise ActionController::ParameterMissing.new("items.#{item_key}")
          end
        end
      end
    end
  end
end
