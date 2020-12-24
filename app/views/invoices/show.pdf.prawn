require "open-uri"



#logo = open("#{RAILS_ROOT}/public/images/sitweb_logo.png")
#pdf.image logo, :position => :left, :height=>50

pdf.image open( "http://localhost:3000/#{image_path('sitweb_logo.png')}" ), :position=>:left, :height=>50


pdf.move_down(1)


#pdf = Prawn::Document.new(
#  :page_size => 'A4',
#  :page_layout => :landscape,
#  :margin => [5.mm])
#  ....
#  .... 
#pdf.table(tbl_data) do
#  row(0).style(:background_color => 'dddddd', :size => 9, :align => :center, :font_style => :bold)
#  column(0).style(:background_color => 'dddddd', :size => 9, :padding_top => 20.mm, :font_style => :bold)
#  row(1).column(1..7).style(:size => 8, :padding => 3)
#  cells[0,0].background_color = 'ffffff'
#  row(0).height = 8.mm
#  row(1..3).height = 45.mm
#  column(0).width = 28.mm
#  column(1..7).width = 35.mm
#  row(1..3).column(6..7).borders = [:left, :right]
#  ....
#  pdf.render()
#


items = [[ "","#{Firm.first.name}"," ", "Klant:","#{@invoice.client.name}"                    ]]
items << [ ""     , "Pelikaanstraat 42 bus 44\n2018 Antwerpen", "","", "#{@invoice.client.address}" ]
items << [ "BTW:",                "#{Firm.first.vat}"     , "", "BTW:"    ,"#{@invoice.client.vat}"    ]
items << [ "Rek:",               "#{Firm.first.bank}"    , " ", "Rek:"  ,""   ]
items << [ "GSM:",                "#{Firm.first.phone}"   , " ", "GSM:", "#{@invoice.client.phone}"   ]
items << [ "Fax:",                "#{Firm.first.fax}"     , " ", "Fax:", "#{@invoice.client.fax}"   ]
items << [ "Email:",              "#{Firm.first.email}"   , " ", "Email:", "#{@invoice.client.email}"   ]


pdf.table( items ) do 
  cells.background_color='ffffff'
  cells.border_color='ffffff'
  cells.padding = 1
  position = 'left'
  column(0).width = 50
  column(3).width = 50
end


pdf.move_down(20)

#todo switch between FACTUUR/OFFERTE according to settings here...
items = [ ["#{@invoice.title}", "", "Datum:",@invoice.datum.strftime("%d/%m/%Y")]]

pdf.table( items ) do 
  align= {0=>:left, 1=>:right, 2=>:right, 3=>:right }
  cells.background_color='ffffff'
  cells.border_color='ffffff'
  cells.padding = 1
  position = 'left'
  column(0).width = 280 
  column(1).width = 55
  column(2).width = 40
  column(3).width = 80
end


pdf.move_down(10)

items = [[ "Beschrijving", "Aantal", "Prijs ex BTW", "Totaal" ]]
if( @invoice.invoice_lines.count > 0 )

  #todo refactor invoice_lines to calculate the totals = price*qty
  @invoice.invoice_lines.map do |item|  
    items << [  
      item.description.to_s,  
      item.qty.to_s,  
      to_euro( item.price ),
      to_euro( item.total )
      ]  
  end

else
  items = [["" , "" , "" , "" ]]
end

pdf.table( items ) do 
  align= {0=>:left, 1=>:right, 2=>:right, 3=>:right }
  cells.background_color='ffffff'
  cells.border_color='000000'
  cells.padding = 1
  row(0).background_color = 'dddddd'
  row(0).border_color = '000000'
  column(0..3).borders = []
  row(0).column(0..3).borders = [:bottom]
  position = 'left'
  column(0).width = 260 
  column(1).width = 40
  column(2).width = 80
  column(3).width = 70
end

pdf.move_down(20)

if @invoice.no_vat
  items =           [  ["","Totaal" ,  "", to_euro( @invoice.total_ex_vat )] ]
else
  items =           [  ["","Totaal excl. BTW" ,  "", to_euro( @invoice.total_ex_vat )] ]
  items = items <<  [   "","BTW"              ,  "", to_euro( @invoice.vat )  ] 
end

pdf.table( items ) do 
  cells.background_color='ffffff'
  cells.border_color='000000'
  cells.align = :right
  cells.padding = 1
  position = 'left'
  column(0..3).borders = []
  row(0).column(0..3).borders = [:top]
 
  column(0).width = 150 
  column(1).width = 160
  column(2).width = 10
  column(3).width = 125
end

unless @invoice.no_vat
  items = [  ["", "Totaal incl. BTW" , "", to_euro(@invoice.total) ] ]

  pdf.table( items ) do 
    cells.background_color='ffffff'
    cells.border_color='000000'
    cells.align = :right
    cells.padding = 1
    position = 'left'
    column(0..3).borders = []
    row(0).column(0..3).borders = [:top]
   

    column(0).width = 150 
    column(1).width = 160
    column(2).width = 10
    column(3).width = 125
  end

end

pdf.move_down( 50 )  
if( @invoice.offerte )
  pdf.text "Gelieve deze #{@invoice.title} te bevestigen via email : info@sitweb.eu"
else

  if @invoice.no_vat
    # ING
    # pdf.text "Gelieve #{@invoice.total_ex_vat } euro te storten op rekening IBAN: BE63 3630 5550 9908 BIC: BBRUBEBB met gestructureerde mededeling #{@invoice.mededeling}", :size => 12, :style => :bold  
    
    # KBC
    pdf.text "Gelieve #{@invoice.total_ex_vat } euro te storten op rekening KBC IBAN: #{Firm.first.bank} BIC: KREDBEBB met gestructureerde mededeling #{@invoice.mededeling}", :size => 12, :style => :bold  
  else
    # ING
    # pdf.text "Gelieve #{@invoice.total } euro te storten op rekening IBAN: BE63 3630 5550 9908 BIC: BBRUBEBB met gestructureerde mededeling #{@invoice.mededeling}", :size => 12, :style => :bold  
    
    # KBC
    pdf.text "Gelieve #{@invoice.total } euro te storten op rekening KBC IBAN: #{Firm.first.bank} BIC: KREDBEBB met gestructureerde mededeling #{@invoice.mededeling}", :size => 12, :style => :bold  
  end

end

