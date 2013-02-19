class ApplicationController < ActionController::Base
  protect_from_forgery
  include MainHelper

  def is_user?
    redirect_to new_user_session_path unless user_signed_in?
  end
end
