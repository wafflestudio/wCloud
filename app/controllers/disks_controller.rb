class DisksController < ApplicationController
  layout :false, :only => [:new, :edit, :show, :summary]

  before_filter :check_user
  before_filter :check_me, :except => [:index, :new, :create]

  def index
    @disks = current_user.disks.page(params[:page]).per(10)
  end

  def new
    @disk = Disk.new
    @disk_specs = DiskSpec.where(:active => true)
  end

  def create
    @disk = current_user.disks.new(params[:disk])
    @disk.path = disk_root+"/"+@disk._id+".vhd"

    if @disk.save
      if create_disk(@disk, "")
        flash[:return] = {:status => true, :msg => ""}
      else
        flash[:return] = {:status => false, :msg => "Failed to create instance"}
        destroy_disk(@disk) if @disk.destroy
      end
    else
      flash[:return] = {:status => false, :msg => @disk.errors.full_messages.to_s}
    end
  end

  def show
    #@disk = Disk.find(params[:id])
  end

  def summary
    #@disk = Disk.find(params[:id])
    @disk_specs = [@disk.disk_spec]
  end

  def edit
    #@disk = Disk.find(params[:id])
    @disk_specs = [@disk.disk_spec]
  end

  def update
    #@disk = Disk.find(params[:id])
    @disk.update_attributes(params[:disk]) 
  end

  def destroy
    #@disk = Disk.find(params[:id])
    if @disk.protected
    else
      @disk.destroy 
    end
    redirect_to disks_path
  end

  def attach
    #@disk = Disk.find(params[:id])
    #TODO
  end

  def detach
    #@disk = Disk.find(params[:id])
    #TODO
  end

  private
  def check_me
    @disk = Disk.find(params[:id])
    redirect_to disks_path if @disk.user != current_user
  end
end
