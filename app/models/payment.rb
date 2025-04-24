class Payment < ApplicationRecord
  belongs_to :order

  validates :payment_method, presence: true
  validates :transaction_id, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed refunded] }
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :currency, presence: true

  def amount
    amount_cents / 100.0
  end

  def completed?
    status == 'completed'
  end

  def failed?
    status == 'failed'
  end

  def pending?
    status == 'pending'
  end

  def processing?
    status == 'processing'
  end

  def refunded?
    status == 'refunded'
  end
end 