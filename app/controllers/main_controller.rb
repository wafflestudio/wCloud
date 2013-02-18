class MainController < ApplicationController
  before_filter :is_user?

  def home
  end
end
