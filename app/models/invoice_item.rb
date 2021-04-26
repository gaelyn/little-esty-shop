class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :transactions, through: :invoice
  has_many :bulk_discounts, through: :item

  validates_presence_of :quantity,
                        :unit_price,
                        :status,
                        :item_id,
                        :invoice_id

  enum status: [:pending, :packaged, :shipped]

  def self.total_revenue
    sum("quantity * unit_price")
  end

  def self.best_item_sale_day
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').
    joins(:transactions).
    where(transactions: {result: :success}).
    group('invoices.id').
    order("revenue", "invoices.created_at").
    last.
    created_at
  end

  def self.items_not_shipped
    joins(:item, :invoice).
    select('invoices.created_at', 'items.name', 'invoices.id').
    order('invoices.created_at').
    where.not(status: 2)
  end

######## NEED TEST ###########
  def self.discount_percent
    joins(:bulk_discounts).
    select('bulk_discounts.*', 'invoice_items.*').
    where('bulk_discounts.minimum_quantity <= invoice_items.quantity').
    order('bulk_discounts.percentage DESC')
    # pluck('bulk_discounts.percentage.first')
    # .first.percentage => 0.75
  end

  ##############################################################################
  # InvoiceItem.joins(item: :bulk_discounts).select('bulk_discounts.*').where('invoice_items.quantity >= bulk_discounts.minimum_quantity').group('bulk_discounts.id')[0].id
end
