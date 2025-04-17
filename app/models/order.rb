class Order < ApplicationRecord
  belongs_to :user
  belongs_to :crate_type
  has_many :ordered_crates, dependent: :destroy

  validates :user, presence: true
  validates :crate_type, presence: true
  validates :status, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Define possible statuses
  enum status: {
    pending: 'pending',
    processing: 'processing',
    paid: 'paid',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  # Callbacks
  before_validation :set_default_status, on: :create
  before_validation :calculate_total_price

  # Helper methods
  def add_crate(crate_type, customization_options = {})
    ordered_crates.create!(
      crate_type: crate_type,
      customization_options: customization_options
    )
  end

  def total_items
    ordered_crates.count
  end

  def self.ransackable_associations(auth_object = nil)
    ["crate_type", "ordered_crates", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "status", "total_price", "updated_at"]
  end

  private

  def set_default_status
    self.status ||= :pending
  end

  def calculate_total_price
    return if ordered_crates.empty?
    
    self.total_price = ordered_crates.sum do |crate|
      crate.crate_type.price
    end
  end
end
