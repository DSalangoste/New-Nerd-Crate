class Category < ApplicationRecord
  has_and_belongs_to_many :crate_types

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["crate_types"]
  end
end
