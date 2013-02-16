module MainHelper
  def get_info
    json = `#{xl} list -l`
    JSON.parse(json)
  end

  def get_perf
    json = `#{xen_perf}`
    JSON.parse(json)
  end

  def create_vm(instance)
    return false unless instance.is_a?(Instance)
    config_path = instance_dir+"/config"

    system("#{xl} create #{config_path}")
  end

  def destroy_vm(instance)
    return false unless instance.is_a?(Instance)

    system("#{xl} destroy #{instance._id}")
  end

  def stutdown_vm(instance)
    return false unless instance.is_a?(Instance)

    system("#{xl} shutdown #{instance._id}")
  end

  def reboot_vm(instance)
    return false unless instance.is_a?(Instance)

    system("#{xl} reboot #{instance._id}")
  end

  def pause_vm(instance)
    return false unless instance.is_a?(Instance)

    system("#{xl} pause #{instance._id}")
  end

  def unpause_vm(instance)
    return false unless instance.is_a?(Instance)

    system("#{xl} unpause #{instance._id}")
  end



  def rename_domname(domname, newdomname)
    system("#{xl} rename #{domname} #{newdomname}")
  end

  def domname_to_domid(domname)
    `#{xl} domid #{domname}"`
  end

  def domid_to_domname(domid)
    `#{xl} domname #{domid}"`
  end

  def create_disk(disk)
    return false unless disk.is_a?(Disk)

    if disk.parent.nil?
      system("#{vhd_util} create -n #{disk.path} -s #{disk.size * Disk::GB}")
    else
      system("#{vhd_util} snapshot -n #{disk.path} -p #{disk.parent.path}")
    end
  end

  def attach_disk(disk, instance)
    return false unless disk.is_a?(Disk)
    return false unless instance.is_a?(Instance)

    if disk.disk_spec == DiskSpec::HDD
      system("#{xl} block-attach #{instance._id} tap:vhd:#{disk.path} #{disk.vdev} #{disk.mode == Disk::WRITE ? 'w' : 'r'}")
    elsif disk.disk_spec == DiskSpec::CDROM
      #TODO
    end
  end

  def create_snapshot(snapshot)
    return false unless snapshot.is_a?(Snapshot)

    snapshot.disks.each do |disk|
      system("#{vhd_util} snapshot -n #{disk.path} -p #{disk.parent.path}")
    end
  end

  private
  def prepare_vm(instance)
    return false unless instance.is_a?(Instance)

    system("mkdir #{instance_dir}")
  end

  def clean_vm(instance)
    return false unless instance.is_a?(Instance)

    system("rm -rf #{instance_dir}")
  end

  def generate_config(instance)
    return false unless instance.is_a?(Instance)
    config_path = instance_dir+"/config"

    name = instance._id
    memory = instance.instance_spec.ram
    vcpus = instance.instance_spec.core
    vif = instance.networks.map {|network|
      "mac=#{network.mac},ip=#{network.ip},bridge=#{network_spec.bridge}"
    }
    disk = instance.disks.map {|disk|
      if disk.disk_spec.type == DiskSpec::HDD
        "tap:vhd:#{disk.path},#{disk.vdev},#{disk.mode == Disk::WRITE ? 'w' : 'r'}"
      elsif disk.disk_spec.type == DiskSpec::CDROM
        "file:#{disk.path},#{disk.vdev}:cdrom,#{disk.mode == Disk::WRITE ? 'w' : 'r'}"
      end
    }

    File.open(config_path, "w") do |f|
      f.puts  "name=#{name}"
      f.puts  "memory=#{memory}"
      f.puts  "vcpus=#{vcpus}"
      f.puts  "vif=#{vif.to_s}"
      f.puts  "disk=#{disk.to_s}"
      
      if instance.instance_spec == InstanceSpec::PVM
        f.puts "bootloader=pygrub"
      elsif instance.instance_spec == InstanceSpec::HVM
        f.puts "builder=hvm"
        f.puts "vnc=1"
        f.puts "vnclisten=0.0.0.0"
        f.puts "vncpassword=#{instance.vncpassword}"
        f.puts "usb=1"
        f.puts "usbdevice=tablet"
      end
    end
  end

  def instance_root
    Cloud::INSTANCE_ROOT
  end
  def instance_dir(instance)
    instance_root+"/"+instance._id
  end
  def disk_root
    Cloud::DISK_ROOT
  end
  def template_root
    Cloud::TEMPLATE_ROOT
  end
  def xl
    Xen::XL
  end
  def vhd_util
    Xen::VHDUTIL
  end
  def tap_ctl
    Xen::TAPCTL
  end
  def xen_perf
    Rails.root+"scripts/xen-perf"
  end
end
