# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_201_224_161_009) do
  create_table 'clients', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.integer 'firm_id'
    t.string 'name'
    t.string 'email'
    t.string 'phone'
    t.string 'fax'
    t.string 'vat'
    t.string 'bank'
    t.text 'address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'firms', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.string 'logo'
    t.string 'name'
    t.string 'email'
    t.string 'phone'
    t.string 'fax'
    t.string 'vat'
    t.string 'bank'
    t.text 'address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'invoice_lines', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.integer 'invoice_id'
    t.text 'description'
    t.integer 'qty'
    t.decimal 'price', precision: 10
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'invoices', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.integer 'client_id'
    t.integer 'firm_id'
    t.integer 'number'
    t.boolean 'offerte'
    t.boolean 'no_vat'
    t.datetime 'datum'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'messages', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.string 'name'
    t.text 'msg'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
