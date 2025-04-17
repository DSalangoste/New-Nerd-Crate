class CrateType < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :orders
  has_many :ordered_crates

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "orders", "ordered_crates"]
  end
end
