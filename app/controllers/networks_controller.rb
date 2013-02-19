class NetworksController < ApplicationController
  layout :false, :only => [:edit, :summary]

  before_filter :is_user?
  before_filter :can_access?, :except => [:index]

  def index
    @networks = current_user.networks.page(params[:page]).per(10)
  end

  def show
    #@network = Network.find(params[:id])
  end

  def summary
    #@network = Network.find(params[:id])
  end

  def edit
    #@network = Network.find(params[:id])
  end

  def update
    #@network = Network.find(params[:id])
    @network.update_attributes(params[:network]) 
  end

  private
  def can_access?
    @network = Network.find(params[:id])
    redirect_to networks_path if @network.nil? || @network.user != current_user
  end
end
