class CrateType < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :ordered_crates

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :search_by_keyword, ->(keyword) {
    where("LOWER(crate_types.name) LIKE :keyword OR LOWER(crate_types.description) LIKE :keyword", 
          keyword: "%#{keyword.downcase}%") if keyword.present?
  }

  scope :filter_by_category, ->(category_id) {
    joins(:categories).where(categories: { id: category_id }) if category_id.present?
  }

  def self.search(search_params)
    crates = all
    
    if search_params[:search].present?
      crates = crates.search_by_keyword(search_params[:search])
    end
    
    if search_params[:category_id].present?
      crates = crates.filter_by_category(search_params[:category_id])
    end
    
    crates
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "orders", "ordered_crates"]
  end
end
