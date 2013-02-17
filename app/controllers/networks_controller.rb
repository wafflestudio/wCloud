class NetworksController < ApplicationController
  layout :false, :only => [:edit]

  def index
    @networks = current_user.networks.page(params[:page]).per(11)
  end

  def show
    @network = Network.find(params[:id])
  end

  def edit
    @network = Network.find(params[:id])
  end

  def update
    @network = Network.find(params[:id])
    @network.update_attributes(params[:network]) 
  end
end
