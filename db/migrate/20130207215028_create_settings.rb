class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :product_name
      t.float :project_goal
      t.string :product_description
      t.string :product_image_path
      t.string :value_proposition
      t.string :video_embed_url
      t.boolean :use_video_placeholder
      t.string :amazon_access_key
      t.string :amazon_secret_key
      t.float :price
      t.boolean :use_payment_options
      t.text :payment_description
      t.float :charge_limit
      t.string :primary_stat
      t.string :primary_stat_verb
      t.string :middle_reserve_text
      t.datetime :expiration_date
      t.string :progress_text
      t.string :ships
      t.string :call_to_action
      t.string :price_human
      t.string :dont_give_them_a_reason_to_say_no
      t.string :facebook_app_id
      t.string :tweet_text
      t.string :google_id

      t.timestamps
    end
  end
end
