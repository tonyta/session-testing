class SessionsController < ApplicationController
  def new
    render locals: locals
  end

  def show
    render locals: locals
  end

  def create
    session[:msg] = params[:msg].presence
    redirect_to sessions_path
  end

  def destroy
    reset_session
    redirect_to sessions_path
  end

  private

  def locals
    {
      msg: session[:msg],
      cookies: cookies.to_hash.except("session_id"),
    }
  end
end
