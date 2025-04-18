class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def new
    @address = current_user.addresses.build
    @provinces = Province.all
  end

  def create
    @address = current_user.addresses.build(address_params)
    
    if @address.save
      redirect_to edit_user_registration_path, notice: 'Address was successfully added.'
    else
      @provinces = Province.all
      render :new
    end
  end

  def edit
    @provinces = Province.all
  end

  def update
    if @address.update(address_params)
      redirect_to edit_user_registration_path, notice: 'Address was successfully updated.'
    else
      @provinces = Province.all
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

  def address_params
    params.require(:address).permit(
      :first_name, :last_name, :address_line_1, :address_line_2,
      :city, :province_id, :postal_code, :country, :phone
    )
  end
end 