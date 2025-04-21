class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :crate_types, through: :order_items
  has_one :billing_address, -> { where(address_type: 'billing') }, class_name: 'Address'
  has_one :shipping_address, -> { where(address_type: 'shipping') }, class_name: 'Address'
  has_one :payment

  validates :status, presence: true
  validates :payment_status, inclusion: { in: %w[pending paid failed refunded], allow_nil: true }
  validates :subtotal_cents, :tax_cents, :shipping_cents, :total_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shipping_method, inclusion: { in: %w[standard express], allow_nil: true }

  scope :completed, -> { where(status: :completed) }
  scope :pending, -> { where(status: :pending) }
  scope :processing, -> { where(status: :processing) }
  scope :cart, -> { where(status: :cart) }

  enum status: { cart: 0, pending: 1, processing: 2, completed: 3, cancelled: 4 }

  def total_items
    order_items.sum(:quantity)
  end

  def calculate_totals
    self.subtotal_cents = order_items.sum { |item| item.quantity * item.price_cents }
    self.tax_cents = (subtotal_cents * 0.1).round # 10% tax rate
    self.shipping_cents = shipping_method == 'express' ? 1500 : 500 # $15 for express, $5 for standard
    self.total_cents = subtotal_cents + tax_cents + shipping_cents
  end

  def total
    total_cents / 100.0
  end

  def mark_as_completed
    update(status: :completed, completed_at: Time.current)
  end

  def self.ransackable_associations(auth_object = nil)
    ["crate_types", "order_items", "billing_address", "shipping_address", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "status", "total_cents", "updated_at"]
  end
end
