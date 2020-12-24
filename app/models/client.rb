class Client < ActiveRecord::Base
  #attr_accessible :firm_id, :name, :email, :phone, :fax, :vat, :bank, :address
  belongs_to :firm
  has_many :invoices
  #has_many :firms, through: :invoices

end
