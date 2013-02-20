class MainController < ApplicationController
  before_filter :is_user?

  def home
    @instance = current_user.instances.where(:state => Instance::RUNNING).first
  end
end
