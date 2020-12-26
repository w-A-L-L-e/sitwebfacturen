# frozen_string_literal: true

# Author: Walter Schreppers
# Description:
#   Uses prawn to generate pdf for an invoice
#   Using prawn tends to violate some rubocop style guides. so we disable some here rather than chopping it all
#   up in seperate methods which would make it less maintainable code.

# rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Lint/UselessAssignment, Layout/LineLength
class InvoicePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def to_euro(amount)
    number_to_currency(amount, unit: '€ ').to_s
  end

  def initialize(invoice)
    super(top_margin: 70, left_margin: 80)
    @invoice = invoice

    require 'open-uri'

    pdf = self
    pdf.image "#{Rails.root}/app/assets/images/sitweb_logo.png", position: :left, height: 50
    pdf.move_down(1)

    items = [[@invoice.firm.name.to_s,    '', 'Klant:', @invoice.client.name.to_s]]
    items << [@invoice.firm.address.to_s, '', '', @invoice.client.address.to_s]
    pdf.table(items) do
      cells.background_color = 'ffffff'
      cells.border_color = 'ffffff'
      cells.padding = 1
      position = 'left'
      column(0).width = 200
      column(2).width = 55
    end

    items = [['BTW:',     @invoice.firm.vat.to_s, '', 'BTW:', @invoice.client.vat.to_s]]
    items << ['Rek:',     @invoice.firm.bank.to_s, ' ', 'Rek:', '']
    items << ['GSM:',     @invoice.firm.phone.to_s, ' ', 'GSM:', @invoice.client.phone.to_s]
    items << ['Fax:',     @invoice.firm.fax.to_s, ' ', 'Fax:', @invoice.client.fax.to_s]
    items << ['Email:',   @invoice.firm.email.to_s, ' ', 'Email:', @invoice.client.email.to_s]
    pdf.table(items) do
      cells.background_color = 'ffffff'
      cells.border_color = 'ffffff'
      cells.padding = 1
      position = 'left'
      column(0).width = 50
      column(1).width = 150
      column(3).width = 50
    end

    pdf.move_down(20)

    items = [[@invoice.title.to_s, '', 'Datum:', @invoice.datum.strftime('%d/%m/%Y')]]

    pdf.table(items) do
      align = { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
      cells.background_color = 'ffffff'
      cells.border_color = 'ffffff'
      cells.padding = 1
      position = 'left'
      column(0).width = 290
      column(1).width = 55
      column(2).width = 40
      column(3).width = 80
    end

    pdf.move_down(10)

    items = [['Beschrijving', 'Aantal', 'Prijs ex BTW', 'Totaal']]
    if @invoice.invoice_lines.count.positive?

      @invoice.invoice_lines.map do |item|
        items << [
          item.description.to_s,
          item.qty.to_s,
          to_euro(item.price),
          to_euro(item.total)
        ]
      end

    else
      items = [['', '', '', '']]
    end

    pdf.table(items) do
      align = { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
      cells.background_color = 'ffffff'
      cells.border_color = '000000'
      cells.padding = 1
      row(0).background_color = 'dddddd'
      row(0).border_color = '000000'
      column(0..3).borders = []
      row(0).column(0..3).borders = [:bottom]
      # position = 'center'
      column(0).width = 260
      column(1).width = 40
      column(2).width = 80
      column(3).width = 70
    end

    pdf.move_down(20)

    colw = [150, 160, 10, 125]

    if @invoice.no_vat
      items =           [['', 'Totaal', '', to_euro(@invoice.total_ex_vat)]]
      colw = [250, 60, 10, 125]
    else
      items =           [['', 'Totaal excl. BTW', '', to_euro(@invoice.total_ex_vat)]]
      items = items <<  ['', 'BTW', '', to_euro(@invoice.vat)]
    end

    pdf.table(items) do
      cells.background_color = 'ffffff'
      cells.border_color = '000000'
      cells.align = :right
      cells.padding = 1
      # position = 'center'
      column(0..3).borders = []
      row(0).column(0..3).borders = [:top]

      column(0).width = colw[0]
      column(1).width = colw[1]
      column(2).width = colw[2]
      column(3).width = colw[3]
    end

    if @invoice.no_vat
      items = [['BTW verlegd - BTW te voldoen door medecontractant - ', '', '', '']]
      items << ['art.196 BTW richtlijn 2006/112/EG', '', '', '']
      colw = [300, 10, 10, 125]
    else
      items = [['', 'Totaal incl. BTW', '', to_euro(@invoice.total)]]
    end

    pdf.table(items) do
      cells.background_color = 'ffffff'
      cells.border_color = '000000'
      cells.align = :right
      cells.padding = 1
      # position = 'center'
      column(0..3).borders = []
      row(0).column(0..3).borders = [:top]

      column(0).width = colw[0]
      column(1).width = colw[1]
      column(2).width = colw[2]
      column(3).width = colw[3]
    end

    pdf.move_down(50)
    if @invoice.offerte
      pdf.text "Gelieve deze #{@invoice.title} te bevestigen via email : info@sitweb.eu"
    elsif @invoice.no_vat

      pdf.text "Gelieve #{to_euro(@invoice.total_ex_vat)} te storten op rekening KBC IBAN: #{@invoice.firm.bank} BIC: KREDBEBB met gestructureerde mededeling #{@invoice.mededeling}", size: 12, style: :bold
    # KBC BIC hardcoded, TODO: make this dynamic
    else
      # KBC BIC is hardcoded TODO: make this dynamic
      pdf.text "Gelieve #{to_euro(@invoice.total)} te storten op rekening KBC IBAN: #{@invoice.firm.bank} BIC: KREDBEBB met gestructureerde mededeling #{@invoice.mededeling}", size: 12, style: :bold

    end

    # end initializer
  end

  # end wrapper class
end

# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Lint/UselessAssignment, Layout/LineLength
