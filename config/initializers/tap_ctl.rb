module TapCtl
  CONFIG = YAML.load_file(Rails.root.join("config/tap_ctl.yml"))[Rails.env]
  TAPCTL = CONFIG['tap-ctl']
end
