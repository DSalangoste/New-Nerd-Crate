class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :crate_types, through: :order_items
  has_one :billing_address, -> { where(address_type: 'billing') }, class_name: 'Address', dependent: :destroy
  has_one :shipping_address, -> { where(address_type: 'shipping') }, class_name: 'Address', dependent: :destroy
  has_one :payment, dependent: :destroy

  enum status: { 
    cart: 'cart', 
    pending: 'pending', 
    processing: 'processing', 
    completed: 'completed', 
    shipped: 'shipped',
    cancelled: 'cancelled' 
  }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :payment_status, inclusion: { in: %w[pending paid failed refunded], allow_nil: true }
  validates :subtotal_cents, :tax_cents, :shipping_cents, :total_cents, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, 
            allow_nil: true
  validates :shipping_method, inclusion: { in: %w[standard express], allow_nil: true }

  before_validation :set_default_status, on: :create

  scope :completed, -> { where(status: :completed) }
  scope :pending, -> { where(status: :pending) }
  scope :processing, -> { where(status: :processing) }
  scope :cart, -> { where(status: :cart) }

  def total_items
    order_items.sum(:quantity)
  end

  def calculate_totals
    Rails.logger.debug "Calculating totals for order #{id}"
    Rails.logger.debug "Order items: #{order_items.inspect}"
    
    # Ensure we have a valid subtotal
    self.subtotal_cents = order_items.sum { |item| 
      quantity = item.quantity.to_i
      price = item.price_cents.to_i
      Rails.logger.debug "Item #{item.id}: quantity=#{quantity}, price=#{price}"
      quantity * price
    }
    Rails.logger.debug "Calculated subtotal: #{subtotal_cents}"
    
    # Calculate tax based on the province's tax rate
    tax_rate = if shipping_address&.province&.tax_rate.present?
      shipping_address.province.tax_rate
    else
      Rails.logger.warn "No province found for order #{id}, using default tax rate"
      0.1 # Default to 10% if no province
    end
    Rails.logger.debug "Using tax rate: #{tax_rate}"
    
    # Calculate tax in cents (tax_rate is already a decimal, e.g. 0.15 for 15%)
    self.tax_cents = (subtotal_cents * tax_rate).round
    Rails.logger.debug "Calculated tax: #{tax_cents} (#{tax_rate * 100}% of #{subtotal_cents})"
    
    # Set shipping cost based on method
    self.shipping_cents = case shipping_method
    when 'express'
      1500 # $15 for express
    when 'standard'
      500  # $5 for standard
    else
      Rails.logger.warn "Invalid shipping method '#{shipping_method}' for order #{id}, using standard"
      500  # Default to standard
    end
    Rails.logger.debug "Set shipping cost: #{shipping_cents}"
    
    # Calculate total
    self.total_cents = subtotal_cents + tax_cents + shipping_cents
    Rails.logger.debug "Calculated total: #{total_cents}"
    
    # Ensure all monetary values are valid
    [subtotal_cents, tax_cents, shipping_cents, total_cents].each do |value|
      if value.nil? || value < 0
        Rails.logger.error "Invalid monetary value for order #{id}: #{value}"
        raise "Invalid monetary value: #{value}"
      end
    end
  end

  def total
    total_cents / 100.0
  end

  def paid?
    payment&.completed?
  end

  def payment_pending?
    payment&.pending?
  end

  def payment_failed?
    payment&.failed?
  end

  def payment_refunded?
    payment&.refunded?
  end

  def payment_processing?
    payment&.processing?
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

  private

  def set_default_status
    self.status = :pending
  end
end
