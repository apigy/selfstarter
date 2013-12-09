class Admin::BaseController < ApplicationController
  before_action :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "shipwrecked" && password == "lighthouselabs"
    end
  end
end
