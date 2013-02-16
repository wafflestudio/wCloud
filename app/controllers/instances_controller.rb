class InstancesController < ApplicationController
  def index
    @instance = current_user.instances
  end

  def new
    @instance = Instance.new
  end

  def create
    @instance = Instance.new(params[:instance])
    @instance.save 
  end

  def show
    @instance = Instance.find(params[:id])
  end

  def edit
    @instance = Instance.find(params[:id])
  end

  def update
    @instance = Instance.find(params[:id])
    @instance.update_attributes(params[:instance]) 
  end

  def destroy
    @instance = Instance.find(params[:id])
    @instance.destroy 
  end

  def stop
    @instance = Instance.find(params[:id])
    shutdown_vm(@instance)
  end
  def start
    @instance = Instance.find(params[:id])
    start_vm(@instance)
  end
  def reboot
    @instance = Instance.find(params[:id])
    restart_vm(@instance)
  end
  def forcestop
    @instance = Instance.find(params[:id])
    destroy_vm(@instance)
  end
  def forcereboot
    @instance = Instance.find(params[:id])
    destroy_vm(@instance)
    create_vm(@instance)
  end
  def snapshot
    #TODO
  end
  def restore
    #TODO
  end
  def duplicate
    #TODO
  end
end
