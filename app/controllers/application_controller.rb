class ApplicationController < ActionController::Base
  protect_from_forgery
  include MainHelper

  def check_user
    redirect_to new_user_session_path unless signed_in?
  end
end
