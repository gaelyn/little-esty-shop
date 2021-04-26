class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage
  validates_presence_of :minimum_quantity
  
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
end

# Merchant.invoices => only invoices for one merchant
# Total revenue => invoice_item.quantity * invoice_item.unit_price
# invoice_item.quantity >= bulk_discounts.minimum_quantity
    #Need minimum bulk_discount.minimum_quantity
    # Query each invoice item to see if it meets min. quantity
    # if it does multiply unit_price * (1-bulk_discount.percentage)
