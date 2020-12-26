# frozen_string_literal: true

# Author: Walter Schreppers
# Description: invoice_lines table migration
class CreateInvoiceLines < ActiveRecord::Migration[5.1]
  def change
    create_table :invoice_lines do |t|
      t.integer :invoice_id
      t.text :description
      t.integer :qty
      t.decimal :price

      t.timestamps
    end
  end
end
