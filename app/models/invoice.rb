class Invoice < ActiveRecord::Base
  belongs_to :client
  belongs_to :firm

  has_many :invoice_lines, :dependent=>:destroy
  accepts_nested_attributes_for :invoice_lines, :reject_if=>lambda{|f| f[:description].blank?}, :allow_destroy => true

  def mededeling
    FactuurMededeling.new( number ).mededeling unless self.offerte
  end

  def title
    if( self.offerte )
      title =  "OFFERTE"
      title += ": #{id}" unless id.blank?
    else
      title = "FACTUUR"
      title += ": #{number}" unless number.blank?
    end
    title
  end

  def firm_prefix
    self.firm.name.strip.tr(" ","_")
  end

  def file_name
    if(self.offerte)
      "#{firm_prefix}_offerte_#{id}.pdf"
    else
      "#{firm_prefix}_factuur_#{number}.pdf"
    end
  end
  
  def getnumber
    if offerte 
      id.to_s
    else
      number.to_s
    end
  end
  
  def set_invoice_number( isofferte )
     unless( isofferte.to_i == 1 )
      last_invoice = Invoice.order("number").last()

      if last_invoice
        self.number = last_invoice.number+1
      else
        #generate invoice nr based on year+month
        self.number = (Time.new.strftime('%Y%m').to_s+'0001').to_i
      end
    end
  end

  def total_ex_vat
    total = 0.0
    for item in invoice_lines
      total += item.total unless item.total.blank?
    end
    total 
  end

  def vat
    (total_ex_vat*0.21).round(2)
  end

  def total
    (total_ex_vat + vat).round(2)
  end

  def to_euro( amount )
    number_to_currency(amount, :unit => '&euro; ').to_s
  end

end


