require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Selfstarter

  class Application < Rails::Application

    # --- Standard Rails Config ---
    config.time_zone = 'Pacific Time (US & Canada)'
    config.encoding = "utf-8"
    config.filter_parameters += [:password]

    #DEPRECATION WARNING: Model based mass assignment security has been extracted
    #out of Rails into a gem. Please use the new recommended protection model for
    #params or add `protected_attributes` to your Gemfile to use the old one.
    #config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    # --- Standard Rails Config ---
  end
end
