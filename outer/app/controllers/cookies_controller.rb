class CookiesController < ApplicationController
  def new
    render locals: {
      target_url: "/cookies",
      redirect_url: nil,
      cookies: cookies.to_hash.except("session_id"),
    }
  end

  def new_third_party
    target_url = if ENV["TUNNEL"] || ENV["IFRAME_TUNNEL"]
      "https://inner.tonyta.dev/cookies"
    else
      "http://innerhost:5101/cookies"
    end

    render :new, locals: {
      target_url: target_url,
      redirect_url: sessions_url,
      cookies: cookies.to_hash.except("session_id"),
    }
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
