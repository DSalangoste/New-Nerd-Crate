class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    # Only allow safe attributes to be searchable
    ["created_at", "email", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end
end
