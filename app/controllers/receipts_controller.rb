class ReceiptsController < ApplicationController

  def points
    @receipt = Receipt.last
    render json: @receipt, include: :items
  end

  def create
    @receipt = Receipt.new(receipt_params)
    if @receipt.save
      render json: @receipt, include: :items, status: :created
    else
      render json: { errors: @receipt.errors }, status: :unprocessable_entity
    end
  end

  private

  def receipt_params
    params.require(:receipt).permit(
      :retailer,
      :purchase_date,
      :purchase_time,
      :total,
      items_attributes: [:short_description, :price]
    )
  end
end
