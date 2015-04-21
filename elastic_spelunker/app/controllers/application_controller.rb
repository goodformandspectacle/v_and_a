class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_cache_header(seconds)
    unless Rails.env.development?
      response.headers = {"Cache-Control" => "public, max-age=#{seconds}"}
    end
  end
end
