# frozen_string_literal: true

# Author: Walter Schreppers
# Description: invoices table migration
class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.integer :client_id
      t.integer :firm_id
      t.integer :number
      t.boolean :offerte
      t.boolean :no_vat
      t.datetime :datum

      t.timestamps
    end
  end
end
