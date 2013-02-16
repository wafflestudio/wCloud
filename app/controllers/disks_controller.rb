class DisksController < ApplicationController
  def index
    @disk = current_user.disks
  end

  def new
    @disk = Disk.new
  end

  def create
    @disk = Disk.new(params[:disk])
    @disk.save 
  end

  def show
    @disk = Disk.find(params[:id])
  end

  def edit
    @disk = Disk.find(params[:id])
  end

  def update
    @disk = Disk.find(params[:id])
    @disk.update_attributes(params[:disk]) 
  end

  def destroy
    @disk = Disk.find(params[:id])
    @disk.destroy 
  end

  def attach
    @disk = Disk.find(params[:id])
    #TODO
  end

  def detach
    @disk = Disk.find(params[:id])
    #TODO
  end
end
