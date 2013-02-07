class Settings < ActiveRecord::Base
attr_accessible :amazon_access_key, :amazon_secret_key, :call_to_action, :charge_limit, :dont_give_them_a_reason_to_say_no, :expiration_date, :facebook_app_id, :google_id, :middle_reserve_text, :payment_description, :price, :price_human, :primary_stat, :primary_stat_verb, :product_description, :product_image_path, :product_name, :progress_text, :project_goal, :ships, :tweet_text, :use_payment_options, :use_video_placeholder, :value_proposition, :video_embed_url, :admin_created
end
