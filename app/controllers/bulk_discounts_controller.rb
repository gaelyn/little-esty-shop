class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = BulkDiscount.all
    if Rails.env.test?
      # Mock data to avoid API throttling limits
      @holidays = ["Memorial Day", "Independence Day", "Labor Day"]
    else
      @holidays = HolidayService.get_holidays.take(3)
    end
  end

  # def index
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @discounts = BulkDiscount.all
  # end

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
    @discount.update!(bulk_discount_params)
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts/#{@discount.id}"
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :minimum_quantity, :merchant_id)
  end
end
