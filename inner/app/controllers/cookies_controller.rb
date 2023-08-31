class CookiesController < ApplicationController
  def new
    render locals: { cookies: cookies.to_hash.except("session_id") }
  end

  def create
    cookie_data = {}
    cookie_data[:value] = "true"
    cookie_data[:secure] = params[:secure] == "1"
    cookie_data[:httponly] = params[:httponly] == "1"
    cookie_data[:same_site] = params[:same_site]
    cookies[params.require(:key)] = cookie_data

    redirect_to sessions_path
  end

  def destroy
    cookies.each do |key, _|
      cookies.delete(key) unless key == "session_id"
    end

    redirect_to sessions_path
  end
end
