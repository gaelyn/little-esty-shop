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
    # joins(:bulk_discounts).
    # select('bulk_discounts.*', 'invoice_items.*').
    # where('bulk_discounts.minimum_quantity <= invoice_items.quantity').
    # order('bulk_discounts.percentage DESC')
    # # pluck('bulk_discounts.percentage')
    # # .first.percentage => 0.75

    # joins(:bulk_discounts).
    # where('bulk_discounts.minimum_quantity <= invoice_items.quantity').
    # select('bulk_discounts.percentage', 'invoice_items.quantity', 'invoice_items.unit_price').
    # order('bulk_discounts.percentage DESC')

    joins(:bulk_discounts).
    where('bulk_discounts.minimum_quantity <= invoice_items.quantity').
    group('invoice_items.id').
    select('invoice_items.*', 'MAX (bulk_discounts.percentage) as percent')


    # The math for above method
    # discounts = @merchant.eligible_invoice_items.discount_percent
    # (discounts.first.unit_price * (1 - discounts.first.percentage)) * discounts.first.quantity
  end

  def self.discounted_revenue
     self.discount_percent.sum do |item|
      (item.unit_price * (1 - item.percent)) * item.quantity
     end
  end

  def self.minimum_discount_quantity_threshold
    joins(:bulk_discounts).minimum(:minimum_quantity)
  end

  def self.eligible_invoice_items
    threshold = self.minimum_discount_quantity_threshold
    where('invoice_items.quantity >= ?', threshold).
    discounted_revenue
  end

  def self.non_eligible_invoice_items
    threshold = self.minimum_discount_quantity_threshold
    where('invoice_items.quantity < ?', threshold).
    sum('invoice_items.quantity*invoice_items.unit_price')
    # invoice_items.non_eligible_invoice_items.sum('invoice_items.quantity*invoice_items.unit_price')
    # 529655
  end

  def self.total_revenue_with_discount
    self.eligible_invoice_items + self.non_eligible_invoice_items
  end

  def find_discount_id
    q = self.quantity
    self.bulk_discounts.where('minimum_quantity <= ?', q).
    select('id', 'percentage').
    order('percentage desc').
    first.
    id
  end

  ##############################################################################
  # InvoiceItem.joins(item: :bulk_discounts).select('bulk_discounts.*').where('invoice_items.quantity >= bulk_discounts.minimum_quantity').group('bulk_discounts.id')[0].id
end
