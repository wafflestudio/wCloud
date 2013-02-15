module VhdUtil
  CONFIG = YAML.load_file(Rails.root.join("config/vhd_util.yml"))[Rails.env]
  VHDUTIL = CONFIG['vhd-util']
end
