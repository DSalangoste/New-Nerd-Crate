class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]
  before_action :load_provinces, only: [:new, :create, :edit, :update]

  def new
    @address = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.build(address_params)
    
    # If this is the first address of its type, make it default
    if current_user.addresses.where(address_type: @address.address_type).count == 0
      @address.default = true
    end
    
    if @address.save
      redirect_to edit_user_registration_path, notice: 'Address was successfully added.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to edit_user_registration_path, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to edit_user_registration_path, notice: 'Address was successfully removed.'
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def load_provinces
    @provinces = Province.order(:name)
  end

  def address_params
    params.require(:address).permit(
      :first_name, :last_name, :address_line_1, :address_line_2,
      :city, :province_id, :postal_code, :country, :phone,
      :address_type, :default
    )
  end
end 