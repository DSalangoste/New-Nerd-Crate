class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :crate_type

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_price_from_crate_type, on: :create

  def total_cents
    quantity * (price_cents || 0)
  end

  private

  def set_price_from_crate_type
    return if price_cents.present?
    self.price_cents = (crate_type&.price.to_f * 100).to_i if crate_type&.price
  end
end 