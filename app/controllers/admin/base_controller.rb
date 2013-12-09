class Admin::BaseController < ApplicationController
  http_basic_authenticate_with name: "shipwrecked", password: "lighthouselabs"
end
