class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_settings
  
  def initialize_settings
    @settings = Settings.find_by_id(1)   
    if(!@settings)
      redirect_to :status => 404
    end
  end
  
end
