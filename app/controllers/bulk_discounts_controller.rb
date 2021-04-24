class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = BulkDiscount.all
  end

  def show

  end

  private

  def _params
    params.permit(:percentage, :minimum_quantity, :merchant_id)
  end
end
