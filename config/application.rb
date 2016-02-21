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
    # Enable the asset pipeline
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    # --- Standard Rails Config ---
    config.action_dispatch.default_headers['X-Frame-Options'] = "ALLOW-FROM https://www.youtube.com"
    config.autoload_paths += %W(#{config.root}/lib)
  end
end