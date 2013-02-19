module Cloud
  CONFIG = YAML.load_file(Rails.root.join("config/cloud.yml"))[Rails.env]
  ROOT = CONFIG['root']

  INSTANCE_ROOT = CONFIG['instance_root']
  DISK_ROOT = CONFIG['disk_root']
  TEMPLATE_ROOT = CONFIG['template_root']
end
