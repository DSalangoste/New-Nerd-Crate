class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :order, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true
  validates :phone, presence: true
  validates :province_id, presence: true

  before_save :ensure_single_default

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    [
      address_line_1,
      address_line_2,
      "#{city}, #{province.code} #{postal_code}",
      country
    ].compact.reject(&:blank?).join("\n")
  end

  private

  def ensure_single_default
    return unless default? && address_type.present?
    
    # If this address is being set as default, unset any other default of the same type
    user.addresses
        .where(address_type: address_type, default: true)
        .where.not(id: id)
        .update_all(default: false)
  end
end 