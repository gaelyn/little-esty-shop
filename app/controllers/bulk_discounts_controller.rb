class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = BulkDiscount.all
    @holidays = HolidayService.get_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])

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

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])

    if (params[:bulk_discount][:percentage] != "") && (params[:bulk_discount][:minimum_quantity] != "")
      @discount.update(bulk_discount_params)
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts/#{@discount.id}"
    else
      flash[:error] = "Please fill in all fields."
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :minimum_quantity, :merchant_id)
  end
end
