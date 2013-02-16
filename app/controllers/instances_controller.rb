class InstancesController < ApplicationController
  layout :false, :only => [:new, :edit]

  def index
    @instance = current_user.instances
  end

  def new
    @instance = Instance.new
    @templates = Template.where(:active => true)
    @instance_specs = InstanceSpec.where(:active => true)
  end

  def create
    @instance = current_user.instances.new(params[:instance])
    prepare_vm(@instance)

    @disk = @instance.disks.new
    @disk.disk_spec = DiskSpec.first
    @disk.path = instance_dir+"/"+@disk._id
    @disk.vdev = @instance.instance_spec.type == InstanceSpec::PVM ? "xvda" : "hda"
    @disk.attached = true
    create_disk(@disk)

    @network = @instance.networks.new
    @network.network_spec = NetworkSpec.first
    @network.mac =  ""
    @network.ip =  ""

    if @instance.save 
      if generate_config(@instance) && create_vm(@instance) 
        flash[:return] = {:status => true, :msg => ""}
      else
        flash[:return] = {:status => false, :msg => "Failed to create instance"}
        clean_vm(@instance)
      end
    else
      flash[:return] = {:status => false, :msg => @instance.errors.full_messages.to_s}
        clean_vm(@instance)
    end
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
