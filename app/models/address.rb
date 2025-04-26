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
  validates :address_type, presence: true, inclusion: { in: %w[shipping billing] }
  
  # Prevent duplicate addresses of the same type for a user
  validate :no_duplicate_address_type, on: :create
  
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
  
  def no_duplicate_address_type
    return unless user_id.present? && address_type.present?
    
    existing_address = user.addresses
                         .where(address_type: address_type)
                         .where.not(id: id)
                         .first
                         
    if existing_address
      errors.add(:address_type, "you already have a #{address_type} address")
    end
  end
end 