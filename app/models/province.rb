class Province < ApplicationRecord
  has_many :addresses
  
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :tax_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
