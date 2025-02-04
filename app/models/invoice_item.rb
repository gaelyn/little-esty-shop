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

  def self.discount_percent
    joins(:bulk_discounts).
    where('bulk_discounts.minimum_quantity <= invoice_items.quantity').
    group('invoice_items.id').
    select('invoice_items.*', 'MAX (bulk_discounts.percentage) as percent')
  end

  def self.discounted_revenue
     self.discount_percent.sum do |item|
      (item.unit_price * (1 - item.percent)) * item.quantity
     end
  end

  def self.minimum_discount_quantity_threshold
    joins(:bulk_discounts).minimum(:minimum_quantity)
  end

  def self.non_eligible_invoice_items
    threshold = self.minimum_discount_quantity_threshold
    where('invoice_items.quantity < ?', threshold).
    sum('invoice_items.quantity*invoice_items.unit_price')
  end

  def self.total_revenue_with_discount
    self.discounted_revenue + self.non_eligible_invoice_items
  end

  def find_discount_id
    q = self.quantity
    self.bulk_discounts.where('minimum_quantity <= ?', q).
    select('id', 'percentage').
    order('percentage desc').
    first.
    id
  end
end
