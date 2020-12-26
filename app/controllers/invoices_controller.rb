# frozen_string_literal: true

# Author: Walter Schreppers
# Description:
#   Invoices handles both invoices and proforma invoices (offertes).
#   uses nested resource invoice_lines.
#
class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy]

  prawnto prawn: { page_size: 'A4', page_layout: :portrait }, inline: false

  def index
    if params[:q].blank?
      @invoices = Invoice.includes(:client).includes(:invoice_lines).order('number DESC').all
    else
      search = params[:q]
      @invoices = Invoice.includes(:client).includes(:invoice_lines)
                         .joins(:client).joins(:invoice_lines)
                         .where(
                           'number LIKE ? or invoice_lines.description LIKE ? or clients.name LIKE ?',
                           "%#{search}%", "%#{search}%", "%#{search}%"
                         ).order('number DESC').all
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: @invoice.file_name.to_s,
                              type: 'application/pdf',
                              disposition: 'attachment'
      end
    end
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "Factuur met id=#{params[:id]} niet gevonden!"
    redirect_to action: 'index'
  end

  def search
    @invoice = Invoice.find_by_number(params[:id])

    if @invoice.blank?
      flash[:notice] = "Factuur #{params[:id]} niet gevonden!"
    else
      flash[:notice] = 'Factuur gevonden'
      redirect_to action: 'show', id: @invoice.id
    end
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_lines.build
    # @invoice.firm = Firm.first
    @invoice.offerte = true

    @invoice.datum = Date.today
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.generate_number(invoice_params[:offerte])

    if @invoice.save
      flash[:notice] = 'Successfully created invoice.'
      redirect_to @invoice
    else
      render action: 'new'
    end
  end

  def edit; end

  def update
    @invoice.generate_number(invoice_params[:offerte])

    if @invoice.update_attributes(invoice_params)
      flash[:notice] = 'Successfully updated invoice.'
      redirect_to @invoice
    else
      render action: 'edit'
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:notice] = 'Successfully destroyed invoice.'
    redirect_to invoices_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:number, :datum, :client_id,
                                    :firm_id, :offerte, :no_vat,
                                    invoice_lines_attributes:
                                      %i[id description qty price _destroy])
  end
end
