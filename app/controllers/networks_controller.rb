class NetworksController < ApplicationController
  layout :false, :only => [:edit, :summary]

  before_filter :check_user
  before_filter :check_me, :except => [:index]

  def index
    @networks = current_user.networks.page(params[:page]).per(11)
  end

  def show
    #@network = Network.find(params[:id])
  end

  def summary
    #@network = Network.find(params[:id])
    @network_specs = [@network.network_spec]
  end

  def edit
    #@network = Network.find(params[:id])
  end

  def update
    #@network = Network.find(params[:id])
    @network.update_attributes(params[:network]) 
  end

  private
  def check_me
    @network = Network.find(params[:id])
    redirect_to networks_path if @network.user != current_user
  end
end
