class InvoiceLine < ActiveRecord::Base
  
  # TODO: add param filtering (search box)
  # attr_accessible :description, :qty, :price

  belongs_to :invoice
  

  def total
    if( qty.nil? )
      price
    else
      price * qty
    end
  end

end
