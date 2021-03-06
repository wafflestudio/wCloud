module MainHelper
  def get_info(domname = "")
    json = `#{xl} list -l #{domname}`
    json && json.length >=2 ? JSON.parse(json) : []
  end

  def get_perf(instance, lines = 0)
    return [] unless instance.is_a?(Instance)

    `tail -n #{lines} #{instance_dir(instance)}/#{instance._id}.log`.split(/\n/)
  end

  def create_vm(instance)
    return false unless instance.is_a?(Instance)
    config_path = instance_dir(instance)+"/config"

    system("#{xl} create #{config_path}")
  end

  def destroy_vm(instance)
    return false unless instance.is_a?(Instance)

    system("#{xl} destroy #{instance._id}")
  end

  def shutdown_vm(instance)
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
    system("#{xl} rename #{domname} #{newdomname}") #FIXME
  end

  def domname_to_domid(domname)
    `#{xl} domid #{domname}"`
  end

  def domid_to_domname(domid)
    `#{xl} domname #{domid}"`
  end

  def create_disk(disk, parent_path = "")
    return false unless disk.is_a?(Disk)

    if parent_path.nil? || parent_path.empty?
      system("#{vhd_util} create -n #{disk.path} -s #{disk.size}")
    else
      system("#{vhd_util} snapshot -n #{disk.path} -p #{parent_path}")
    end
  end

  def rename_disk(disk, new_path)
    return false unless disk.is_a?(Disk)

    system("mv -f #{disk.path} #{new_path}")
  end

  def copy_disk(disk, target_path)
    return false unless disk.is_a?(Disk)

    system("cp -f #{disk.path} #{target_path}&")
  end

  def destroy_disk(disk)
    return false unless disk.is_a?(Disk)

    system("rm -f #{disk.path}")
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
  
  def pause_disk(pid, minor)
    system("#{tap_ctl} pause -p #{pid} -m #{minor}")
  end

  def unpause_disk(pid, minor)
    system("#{tap_ctl} unpause -p #{pid} -m #{minor}")
  end

  def get_tapinfo(path)
    line = `#{tap_ctl} list | grep #{path}`
    field = line.split(" ")
    json = field.empty? ? {} : {:pid => field[0].split("=").last, :minor => field[1].split("=").last, :state => field[2].split("=").last, :args => field[3].split("=").last}
  end

  def create_snapshot(snapshot)
    return false unless snapshot.is_a?(Snapshot)

    snapshot.disks.each do |disk|
      info = get_tapinfo(disk.path)
      pause_disk(info[:pid], info[:minor])
      rename_disk(disk.path, disk.parent.path)
      system("#{vhd_util} snapshot -n #{disk.path} -p #{disk.parent.path}")
      unpause_disk(info[:pid], info[:minor])
    end
  end

  def xenstore_read(domid, path) # path start_with "/"
    `#{Xen::XENSTOREREAD} /local/domain/#{domid}#{path}`.to_s.gsub(/\n/,'')
  end

  def xenstore_ls(domid, path) # path start_with "/"
    `#{Xen::XENSTORELS} /local/domain/#{domid}#{path}`.to_s.gsub(/\n/,'')
  end

  private
  def prepare_vm(instance)
    return false unless instance.is_a?(Instance)

    system("mkdir -p #{instance_dir(instance)}")
  end

  def clean_vm(instance)
    return false unless instance.is_a?(Instance)

    system("rm -rf #{instance_dir(instance)}")
  end

  def generate_config(instance)
    return false unless instance.is_a?(Instance)
    config_path = instance_dir(instance)+"/config"

    name = instance._id
    memory = instance.instance_spec.ram
    vcpus = instance.instance_spec.core
    vif = instance.networks.map {|network|
      "mac=#{network.mac},bridge=#{network.network_spec.bridge}"
      #"bridge=#{network.network_spec.bridge}"
    }
    disk = instance.disks.map {|disk|
      if disk.disk_spec.type == DiskSpec::HDD
        "tap:vhd:#{disk.path},#{disk.vdev},#{disk.mode == Disk::WRITE ? 'w' : 'r'}"
      elsif disk.disk_spec.type == DiskSpec::CDROM
        "file:#{disk.path},#{disk.vdev}:cdrom,#{disk.mode == Disk::WRITE ? 'w' : 'r'}"
      end
    }

    begin
      File.open(config_path, "w") do |f|
        f.puts  "name='#{name}'"
        f.puts  "memory='#{memory}'"
        f.puts  "vcpus='#{vcpus}'"
        f.puts  "vif=#{vif.to_s}"
        f.puts  "disk=#{disk.to_s}"

        if instance.template.type == Template::PVM
          f.puts "bootloader='pygrub'"
          f.puts "vfb=['type=vnc,vnclisten=0.0.0.0,vncpasswd=#{instance.vncpassword},vncconsole=1']"
        elsif instance.template.type == Template::HVM
          f.puts "builder='hvm'"
          f.puts "vnc='1'"
          f.puts "vnclisten='0.0.0.0'"
          f.puts "vncpasswd='#{instance.vncpassword}'"
          f.puts "usb='1'"
          f.puts "usbdevice='tablet'"
        end
      end
      return true
    rescue
      return false
    end
  end

  def update_config(instance)
    return false unless instance.is_a?(Instance)
    config_path = instance_dir(instance)+"/config"

    system("#{xl} config-update #{instance._id} #{config_path}")
  end

  def get_ip_from_mac(bridge, mac)
    ip = `arp-scan -I #{bridge} -T #{mac} 192.168.0.0/24 | grep #{mac} | awk '{print $1}'`
    ip.to_s.gsub(/\n/,'')
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
