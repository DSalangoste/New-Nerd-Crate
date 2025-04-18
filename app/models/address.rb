class Address < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true
  validates :phone, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    [
      address_line_1,
      address_line_2,
      "#{city}, #{state} #{postal_code}",
      country
    ].compact.reject(&:blank?).join("\n")
  end
end 