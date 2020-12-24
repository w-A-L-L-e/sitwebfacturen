class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  prawnto :prawn=>{:page_size => "A4", :page_layout => :portrait}, :inline=>false

  def index
    #@invoices = Invoice.find( :all, :order=>'number DESC' )
    if params[:q].blank?
      @invoices = Invoice.includes(:client).includes(:invoice_lines).order( "number DESC" ).all()    # Invoice.find( :all, :order=>'number DESC' )
    else
      search = params[:q]
      @invoices = Invoice.includes(:client).includes(:invoice_lines).joins(:client).joins(:invoice_lines).
        where("number LIKE ? or invoice_lines.description LIKE ? or clients.name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%" ).
        order("number DESC").all()
    end

  end
  
  def show
    begin
      #prawnto :filename=>@invoice.file_name  #we do it in the view!
      respond_to do |format|
        format.html
        format.pdf do
          # Prawn::Document.new
          # send_data pdf.render
          pdf = InvoicePdf.new(@invoice)
          send_data pdf.render, filename: "#{@invoice.file_name}",
                              type: "application/pdf",
                              disposition: "attachment"
                              #disposition: "inline"
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Factuur met id=#{params[:id]} niet gevonden!"    
      redirect_to :action => 'index'
    end
    
  end
 
  def search
    @invoice = Invoice.find_by_number( params[:id] )

    if( @invoice.blank? )
      flash[:notice] = "Factuur #{params[:id]} niet gevonden!"
    else
      flash[:notice] = "Factuur gevonden"
      redirect_to :action => 'show', :id=>@invoice.id
    end

  end
 
  def new
    @invoice = Invoice.new
    @invoice.invoice_lines.build
    #@invoice.firm = Firm.first
    @invoice.offerte = true

    @invoice.datum = Date.today
  end
  
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.set_invoice_number( invoice_params[:offerte] )

    if @invoice.save
      flash[:notice] = "Successfully created invoice."
      redirect_to @invoice
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    @invoice.set_invoice_number( invoice_params[:offerte] )
    
    if @invoice.update_attributes(invoice_params)
      flash[:notice] = "Successfully updated invoice."
      redirect_to @invoice
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:notice] = "Successfully destroyed invoice."
    redirect_to invoices_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:number, :datum, :client_id, :firm_id, :offerte, :no_vat, :invoice_lines_attributes=>[ :id, :description, :qty, :price, :_destroy ] )
    end

end

