class ReceiptsController < ApplicationController
  # TODO: Authorization

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
      render json: { errors: @receipt.errors }, status: :unprocessable_entity
    end
  end

  private

  def normalized_receipt_params
    {
      retailer: raw_receipt_params[:retailer],
      purchase_date: raw_receipt_params[:purchase_date],
      purchase_time: raw_receipt_params[:purchase_time],
      total: raw_receipt_params[:total],
      items_attributes: raw_receipt_params[:items]
    }
  end

  def raw_receipt_params
    params.permit(
      :retailer,
      :purchase_date,
      :purchase_time,
      :total,
      items: [ :short_description, :price ]
    )
  end
end
