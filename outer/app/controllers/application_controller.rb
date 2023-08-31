class ApplicationController < ActionController::Base
  skip_forgery_protection unless ENV["TUNNEL"]
end
