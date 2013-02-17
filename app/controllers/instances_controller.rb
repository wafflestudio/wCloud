class InstancesController < ApplicationController
  layout :false, :only => [:new, :edit]

  def index
    @instances = current_user.instances.page(params[:page]).per(3)
  end

  def new
    @instance = Instance.new
    @templates = Template.where(:active => true)
    @instance_specs = InstanceSpec.where(:active => true)
  end

  def create
    @instance = current_user.instances.new(params[:instance])
    prepare_vm(@instance)

    @template = @instance.template

    @disk = @instance.disks.new
    @disk.disk_spec = DiskSpec.first
    @disk.path = instance_dir(@instance)+"/"+@disk._id+".vhd"
    @disk.vdev = @instance.template.type == Template::PVM ? "xvda" : "hda"
    @disk.attached = true
    create_disk(@disk, @template.path) if @disk.save

    @network = @instance.networks.new
    @network.network_spec = NetworkSpec.first
    @network.mac =  ""
    @network.ip =  ""
    @network.save

    if @instance.save 
      if generate_config(@instance) && create_vm(@instance) 
        flash[:return] = {:status => true, :msg => ""}
      else
        flash[:return] = {:status => false, :msg => "Failed to create instance"}
        clean_vm(@instance) if @instance.destroy
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
    clean_vm(@instance)
    @instance.destroy 
  end

  def update_state
    Instance.all.each do |instance|
      case instance.state
      when Instance::CREATING
        network = instance.networks.first
        ip = network.nil? ? "" : get_ip_from_mac(network.network_spec.bridge, network.mac)
        if !ip.empty? && network.update_attribute(:ip, ip)
          instance.update_attribute(:state, Instance::RUNNING)
        end
      when Instance::STOPPING
        info = get_info(instance._id)
        if info.empty? && network.update_attribute(:ip, "")
          instance.update_attribute(:state, Instance::STOPPED)
        end
      when Instance::STARTING
        network = instance.networks.first
        ip = network.nil? ? "" : get_ip_from_mac(network.network_spec.bridge, network.mac)
        if !ip.empty? && network.update_attribute(:ip, ip)
          instance.update_attribute(:state, Instance::RUNNING)
        end
      when Instance::REBOOTING
        info = get_info(instance._id)
        if !info.empty? && info.first['domid'] != instance.domid
          instance.update_attributes({:state => Instance::RUNNING, :domid => info.first['domid']})
        end
      end
    end
  end

  def stop
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::STOPPING)
      shutdown_vm(@instance)
    end
  end
  def start
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::STOPPED && @instance.update_attribute(:state, Instance::STARTING)
      start_vm(@instance)
    end
  end
  def reboot
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::REBOOTING)
      restart_vm(@instance)
    end
  end
  def forcestop
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::STOPPING)
      destroy_vm(@instance)
    end
  end
  def forcereboot
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::REBOOTING)
      destroy_vm(@instance)
      create_vm(@instance)
    end
  end
  def snapshot
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.state == Instance::STOPPED
      #TODO
    end
  end
  def restore
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.state == Instance::STOPPED
      #TODO
    end
  end
  def duplicate
    @instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.state == Instance::STOPPED
      #TODO
    end
  end
end
