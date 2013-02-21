class InstancesController < ApplicationController
  layout :false, :only => [:new, :edit, :summary]

  before_filter :is_user?
  before_filter :can_access?, :except => [:index, :new, :create, :update_state]

  before_filter :update_state, :only => [:index]

  def index
    @instances = current_user.instances.page(params[:page]).per(10)
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
    @disk.user = current_user
    @disk.disk_spec = DiskSpec.first
    @disk.path = instance_dir(@instance)+"/"+@disk._id+".vhd"
    @disk.vdev = @instance.template.type == Template::PVM ? "xvda" : "hda"
    create_disk(@disk, @instance.template.path) if @disk.save

    @network = @instance.networks.new
    @network.user = current_user
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
    #@instance = Instance.find(params[:id])
  end

  def summary
    #@instance = Instance.find(params[:id])
  end

  def edit
    #@instance = Instance.find(params[:id])
    @instance_specs = InstanceSpec.where(:active => true)
  end

  def update
    #@instance = Instance.find(params[:id])
    if @instance.update_attributes(params[:instance]) 
        flash[:return] = {:status => true, :msg => ""}
      else
        flash[:return] = {:status => false, :msg => @instance.errors.full_messages.to_s}
    end
  end

  def destroy
    #@instance = Instance.find(params[:id])
    if @instance.can_destroy?
    else
      destroy_vm(@instance)
      clean_vm(@instance)
      @instance.destroy 
    end
    redirect_to instances_path
  end

  def update_state
    json = []

    Instance.all.each do |instance|
      case instance.state
      when Instance::CREATING
        network = instance.networks.first
        ip = network.nil? ? "" : get_ip_from_mac(network.network_spec.bridge, network.mac)
        if !ip.empty? && network.update_attribute(:ip, ip)
          info = get_info(instance._id).first
          domid = info.empty? ? 0 : info.first['domid']
          vncport = xenstore_read(domid, "/console/vnc-port")
          instance.update_attribute({:state => Instance::RUNNING, :vncport => vncport, :domid => domid})
        end
      when Instance::STOPPING
        info = get_info(instance._id)
        network = instance.networks.first
        if info.empty? && !network.nil? && network.update_attribute(:ip, "")
          instance.update_attribute(:state, Instance::STOPPED)
        end
      when Instance::STARTING
        network = instance.networks.first
        ip = network.nil? ? "" : get_ip_from_mac(network.network_spec.bridge, network.mac)
        if !ip.empty? && network.update_attribute(:ip, ip)
          info = get_info(instance._id).first
          domid = info.empty? ? 0 : info.first['domid']
          vncport = xenstore_read(domid, "/console/vnc-port")
          instance.update_attribute({:state => Instance::RUNNING, :vncport => vncport, :domid => domid})
        end
      when Instance::REBOOTING
        info = get_info(instance._id)
        if !info.empty? && info.first['domid'] != instance.domid
          domid = info.first['domid']
          vncport = xenstore_read(domid, "/console/vnc-port")
          instance.update_attributes({:state => Instance::RUNNING, :vncport => vncport, :domid => domid})
        end
      end
      json << {:id => instance._id, :name => instance.name, :state => instance.state_to_string}
    end

    #render :json => json
  end

  def performance
    #@instance = Instance.find(params[:id])
    json = []
    lines = get_perf(@instance, 100) 
    lines.each do |line|
      elements = line.split(",")
      json << {:date => elements[0], :id => elements[1], :cpu => elements[2], :input => elements[3], :output => elements[4], :read => elements[5], :write => elements[6]}
    end

    render :json => json
  end

  def stop
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::STOPPING)
      if shutdown_vm(@instance)
        json = {:action => "stop", :status => true, :msg => ""}
      else
        json = {:action => "stop", :status => false, :msg => "Failed to stop instance"}
      end
    end
    render :json => json
  end
  def start
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::STOPPED && @instance.update_attribute(:state, Instance::STARTING)
      if generate_config(@instance) && create_vm(@instance)
        json = {:action => "start", :status => true, :msg => ""}
      else
        json = {:action => "start", :status => false, :msg => "Failed to start instance"}
      end
    end
    render :json => json
  end
  def reboot
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::REBOOTING)
      if generate_config(@instance) && update_config(@instance) && reboot_vm(@instance)
        json = {:action => "restart", :status => true, :msg => ""}
      else
        json = {:action => "restart", :status => false, :msg => "Failed to restart instance"}
      end
    end
    render :json => json
  end
  def forcestop
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::STOPPING)
      if destroy_vm(@instance)
        json = {:action => "forcestop", :status => true, :msg => ""}
      else
        json = {:action => "forcestop", :status => false, :msg => "Failed to forcestop instance"}
      end
    end
    render :json => json
  end
  def forcereboot
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.update_attribute(:state, Instance::REBOOTING)
      if destroy_vm(@instance) && generate_config(@instance) && create_vm(@instance)
        json = {:action => "forcereboot", :status => true, :msg => ""}
      else
        json = {:action => "forcereboot", :status => false, :msg => "Failed to forcereboot instance"}
      end
    end
    render :json => json
  end
  def snapshot
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.state == Instance::STOPPED
      #TODO
    end
  end
  def restore
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.state == Instance::STOPPED
      #TODO
    end
  end
  def duplicate
    #@instance = Instance.find(params[:id])
    if @instance.state == Instance::RUNNING && @instance.state == Instance::STOPPED
      #TODO
    end
  end

  private
  def can_access?
    @instance = Instance.find(params[:id])
    redirect_to instances_path if @instance.nil? || @instance.user != current_user
  end
end
