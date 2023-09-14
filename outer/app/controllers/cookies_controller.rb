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
    if cookie_name == "all"
      cookies["secure-httponly-none"]         = { value: true, secure: true,  httponly: true,  same_site: :none   }
      cookies["secure-httponly-lax"]          = { value: true, secure: true,  httponly: true,  same_site: :lax    }
      cookies["secure-httponly-strict"]       = { value: true, secure: true,  httponly: true,  same_site: :strict }
      cookies["nonsecure-httponly-none"]      = { value: true, secure: false, httponly: true,  same_site: :none   }
      cookies["nonsecure-httponly-lax"]       = { value: true, secure: false, httponly: true,  same_site: :lax    }
      cookies["nonsecure-httponly-strict"]    = { value: true, secure: false, httponly: true,  same_site: :strict }
      cookies["secure-nonhttponly-none"]      = { value: true, secure: true,  httponly: false, same_site: :none   }
      cookies["secure-nonhttponly-lax"]       = { value: true, secure: true,  httponly: false, same_site: :lax    }
      cookies["secure-nonhttponly-strict"]    = { value: true, secure: true,  httponly: false, same_site: :strict }
      cookies["nonsecure-nonhttponly-none"]   = { value: true, secure: false, httponly: false, same_site: :none   }
      cookies["nonsecure-nonhttponly-lax"]    = { value: true, secure: false, httponly: false, same_site: :lax    }
      cookies["nonsecure-nonhttponly-strict"] = { value: true, secure: false, httponly: false, same_site: :strict }
    else
      cookie_data = {}
      cookie_data[:value] = "true"
      cookie_data[:secure] = params[:secure] == "1"
      cookie_data[:httponly] = params[:httponly] == "1"
      cookie_data[:same_site] = params[:same_site]
      cookies[params.require(:key)] = cookie_data
    end

    redirect_to sessions_path
  end

  def destroy
    cookies.each do |key, _|
      cookies.delete(key) unless key == "session_id"
    end

    redirect_to sessions_path
  end
end
