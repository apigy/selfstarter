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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130207215028) do

  create_table "orders", :id => false, :force => true do |t|
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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "payment_option_id"
  end

  create_table "payment_options", :force => true do |t|
    t.decimal  "amount"
    t.string   "amount_display"
    t.text     "description"
    t.string   "shipping_desc"
    t.string   "delivery_desc"
    t.integer  "limit"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "product_name"
    t.float    "project_goal"
    t.string   "product_description"
    t.string   "product_image_path"
    t.string   "value_proposition"
    t.string   "video_embed_url"
    t.boolean  "use_video_placeholder"
    t.string   "amazon_access_key"
    t.string   "amazon_secret_key"
    t.float    "price"
    t.boolean  "use_payment_options"
    t.text     "payment_description"
    t.float    "charge_limit"
    t.string   "primary_stat"
    t.string   "primary_stat_verb"
    t.string   "middle_reserve_text"
    t.datetime "expiration_date"
    t.string   "progress_text"
    t.string   "ships"
    t.string   "call_to_action"
    t.string   "price_human"
    t.string   "dont_give_them_a_reason_to_say_no"
    t.string   "facebook_app_id"
    t.string   "tweet_text"
    t.string   "google_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
