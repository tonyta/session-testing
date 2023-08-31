class SessionsController < ApplicationController
  def new
    render locals: { msg: session[:msg] }
  end

  def show
    render locals: { msg: session[:msg] }
  end

  def create
    session[:msg] = params.require(:msg)
    redirect_to sessions_path
  end

  def destroy
    reset_session
    redirect_to sessions_path
  end
end
