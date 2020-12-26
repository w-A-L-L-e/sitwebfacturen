# frozen_string_literal: true

# Author: Walter Schreppers
# Description:
#   Manage your firm(s) TODO: add logo saving and usage of logo
#   in pdfs (right now its hardcoded for sit logo)
#
class FirmsController < ApplicationController
  # GET /firms
  # GET /firms.json
  def index
    @firms = Firm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @firms }
    end
  end

  # GET /firms/1
  # GET /firms/1.json
  def show
    @firm = Firm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @firm }
    end
  end

  # GET /firms/new
  # GET /firms/new.json
  def new
    @firm = Firm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @firm }
    end
  end

  # GET /firms/1/edit
  def edit
    @firm = Firm.find(params[:id])
  end

  # POST /firms
  # POST /firms.json
  def create
    @firm = Firm.new(firm_params)

    respond_to do |format|
      if @firm.save
        format.html { redirect_to @firm, notice: 'Firm was successfully created.' }
        format.json { render json: @firm, status: :created, location: @firm }
      else
        format.html { render action: 'new' }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /firms/1
  # PUT /firms/1.json
  def update
    @firm = Firm.find(params[:id])

    respond_to do |format|
      if @firm.update_attributes(firm_params)
        format.html { redirect_to @firm, notice: 'Firm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /firms/1
  # DELETE /firms/1.json
  def destroy
    @firm = Firm.find(params[:id])
    @firm.destroy

    respond_to do |format|
      format.html { redirect_to firms_url }
      format.json { head :no_content }
    end
  end

  private

  def firm_params
    params.require(:firm).permit(:logo, :name, :email, :phone, :fax, :vat, :bank, :address)
  end
end
