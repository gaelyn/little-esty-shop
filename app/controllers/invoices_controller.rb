class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
    ######## For Bulk Discount user story
    @discounted_invoice_items = @merchant.eligible_invoice_items
    @not_discounted_invoice_items = @merchant.non_eligible_invoice_items
  end
end
