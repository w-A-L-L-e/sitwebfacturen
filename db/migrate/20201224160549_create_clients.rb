class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.integer :firm_id
      t.string :name
      t.string :email
      t.string :phone
      t.string :fax
      t.string :vat
      t.string :bank
      t.text :address

      t.timestamps
    end
  end
end
