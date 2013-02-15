module Cloud
  CONFIG = YAML.load_file(Rails.root.join("config/cloud.yml"))[Rails.env]
  ROOT = CONFIG['root']

  INSTANCE_ROOT = CONFIG['instance_root']
  INSTANCE_DISK_PATH = CONFIG['instance_disk_path']
  INSTANCE_LOG_PATH = CONFIG['instance_log_path']

  DISK_ROOT = CONFIG['disk_root']

  TEMPLATE_ROOT = CONFIG['template_root']
end
