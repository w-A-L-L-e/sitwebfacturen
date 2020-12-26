# frozen_string_literal: true

# Author: Walter Schreppers
# Description:
#   handle company clients crud operations
#
class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = Client.all
  end

  def show; end

  def new
    @client = Client.new
  end

  def create
    # @client = Client.new(params[:client])
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: 'Successfully created client.'
    else
      render action: 'new'
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: 'Successfully updated client.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Successfully destroyed client.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :email, :vat, :phone, :fax, :bank, :address, :firm_id)
  end
end
