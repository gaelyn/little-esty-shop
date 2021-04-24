class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = BulkDiscount.all
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if discount.save
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
    else
      flash[:error] = "Please fill in all fields. #{error_message(discount.errors)}."
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts/new"
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :minimum_quantity, :merchant_id)
  end
end
