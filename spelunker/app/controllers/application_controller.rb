class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # simple HTTP Basic auth.
  #if Rails.env.production?
    #http_basic_authenticate_with name: "gfs", password: "nicetoseeyou", except: :index
  #end
  
end
