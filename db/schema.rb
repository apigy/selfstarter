# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150306231531) do

  create_table "orders", id: false, force: true do |t|
    t.string   "token"
    t.string   "transaction_id"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "status"
    t.string   "number"
    t.string   "uuid"
    t.string   "user_id"
    t.decimal  "price"
    t.decimal  "shipping"
    t.string   "tracking_number"
    t.string   "phone"
    t.string   "name"
    t.date     "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_option_id"
  end

  create_table "payment_options", force: true do |t|
    t.decimal  "amount"
    t.string   "amount_display"
    t.text     "description"
    t.string   "shipping_desc"
    t.string   "delivery_desc"
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_pagar_mes", force: true do |t|
    t.string   "card_number"
    t.string   "card_holder_name"
    t.string   "card_expiration_month"
    t.string   "card_expiration_year"
    t.string   "card_cvv"
    t.string   "card_hash"
    t.string   "payment_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.string   "card_number"
    t.string   "card_holder_name"
    t.string   "card_expiration_month"
    t.string   "card_expiration_year"
    t.string   "card_cvv"
    t.string   "card_hash"
    t.string   "payment_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "amount"
    t.string   "card_hash"
    t.string   "status"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["payment_id"], name: "index_transactions_on_payment_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
