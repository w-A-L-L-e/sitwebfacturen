# frozen_string_literal: true

# Author: Walter Schreppers
# Description:
# Stores invoice in database, linked to client and firm,
# has many invoice lines and has nested attributes for invoice
# lines
class Invoice < ActiveRecord::Base
  belongs_to :client
  belongs_to :firm

  has_many :invoice_lines, dependent: :destroy
  accepts_nested_attributes_for :invoice_lines, reject_if: ->(f) { f[:description].blank? }, allow_destroy: true

  def mededeling
    FactuurMededeling.new(number).mededeling unless offerte
  end

  def title
    if offerte
      title =  'OFFERTE'
      title += ": #{id}" unless id.blank?
    else
      title = 'FACTUUR'
      title += ": #{number}" unless number.blank?
    end
    title
  end

  def firm_prefix
    firm.name.strip.tr(' ', '_')
  end

  def file_name
    if offerte
      "#{firm_prefix}_offerte_#{id}.pdf"
    else
      "#{firm_prefix}_factuur_#{number}.pdf"
    end
  end

  # def getnumber
  #   if offerte
  #     id.to_s
  #   else
  #     number.to_s
  #   end
  # end

  def generate_number(isofferte)
    return id if isofferte.to_i == 1

    # TODO: scope per firm here!
    last_invoice = Invoice.order('number').last

    self.number = if last_invoice
                    last_invoice.number + 1
                  else
                    # generate invoice nr based on year+month
                    "#{Time.new.strftime('%Y%m')}0001".to_i
                  end
  end

  def total_ex_vat
    total = 0.0
    invoice_lines.each do |item|
      total += item.total unless item.total.blank?
    end
    total
  end

  def vat
    (total_ex_vat * 0.21).round(2)
  end

  def total
    (total_ex_vat + vat).round(2)
  end

  def to_euro(amount)
    number_to_currency(amount, unit: '&euro; ').to_s
  end
end
