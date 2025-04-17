class OrderedCrate < ApplicationRecord
  belongs_to :order
  belongs_to :crate_type

  validates :status, presence: true
  validates :order, presence: true
  validates :crate_type, presence: true

  # Store customization_options as JSON
  store_accessor :customization_options

  # Define possible statuses
  enum status: {
    pending: 'pending',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  # Callbacks
  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= :pending
  end
end 