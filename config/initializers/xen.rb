module Xen
  CONFIG = YAML.load_file(Rails.root.join("config/xen.yml"))[Rails.env]
  XL = CONFIG['xl']
  VHDUTIL = CONFIG['vhd-util']
  TAPCTL = CONFIG['tap-ctl']
end
