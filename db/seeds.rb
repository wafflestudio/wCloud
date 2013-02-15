## Admin

admins = [
{:email => "cloud@wafflestudio.com", :password => "rlaxorals"}
]

puts "MODEL::Admin"

admins.each do |admin|
	e = Admin.new
	e.email = admin[:email]
	e.password = admin[:password]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

users = [
{:email => "tantara@wafflestudio.com", :password => "rlaxorals"}
]

puts "MODEL::User"

users.each do |user|
	e = User.new
	e.email = user[:email]
	e.password = user[:password]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

templates = [
{:filename => "CentOS-6.3-2013.02.15.vhd", :name => "CentOS 6.3", :description => "Minimal", :type => Template::PVM, :arch => Template::X86_64},
{:filename => "Ubuntu-12.04.1-2013.02.15.vhd", :name => "Ubunutu 12.04.1", :description => "LTS", :type => Template::PVM, :arch => Template::X86_64},
{:filename => "Debian-6.0-2013.02.15.vhd", :name => "Deiban 6.0", :description => "", :type => Template::PVM, :arch => Template::X86_64},
{:filename => "Windows-8-2013.02.15.vhd", :name => "Windows 8", :description => "Trial 90 days", :type => Template::HVM, :arch => Template::X86_64}
]

puts "MODEL::Template"

templates.each do |template|
	e = Template.new
	e.path = Cloud::TEMPLATE_ROOT+"/"+template[:filename]
	e.active = File.exist?(e.path)
	e.name = template[:name]
	e.description = template[:description]
	e.type = template[:type]
	e.arch = template[:arch]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

instance_specs = [
{:name => "Test", :description => "Minimal option", :ram => 256, :core => 1},
{:name => "Small", :description => "Basic option for Linux", :ram => 512, :core => 1},
{:name => "Medium", :description => "Best option for Linux", :ram => 1024, :core => 1},
{:name => "Large", :description => "Powerful Calculation", :ram => 1024, :core => 2},
{:name => "Extra", :description => "Best option for Windows", :ram => 2048, :core => 2}
]

puts "MODEL::InstanceSpec"

instance_specs.each do |spec|
	e = InstanceSpec.new
	e.active = true
	e.name = spec[:name]
	e.description = spec[:description]
	e.ram = spec[:ram]
	e.core = spec[:core]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

disk_specs = [
{:name => "OS 64GB", :description => "Base Disk", :type => DiskSpec::HDD, :size => 64 * DiskSpec::GB},
{:name => "ownCloud", :description => "Additional Disk", :type => DiskSpec::HDD, :size => 30 * DiskSpec::GB}
]

puts "MODEL::DiskSpec"

disk_specs.each do |spec|
	e = DiskSpec.new
	e.active = true
	e.name = spec[:name]
	e.description = spec[:description]
	e.type = spec[:type]
	e.size = spec[:size]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

network_specs = [
{:name => "Private Network", :description => "Using ipTIME", :type => NetworkSpec::PRIVATE}
]

puts "MODEL::NetworkSpec"

network_specs.each do |spec|
	e = NetworkSpec.new
	e.active = true
	e.name = spec[:name]
	e.description = spec[:description]
	e.type = spec[:type]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end

network_pools = [
{:ip => "192.168.0.200", :port => {}},
{:ip => "192.168.0.201", :port => {}},
{:ip => "192.168.0.202", :port => {}},
{:ip => "192.168.0.203", :port => {}},
{:ip => "192.168.0.204", :port => {}},
{:ip => "192.168.0.205", :port => {}}
]

puts "MODEL::NetworkPool"

network_pools.each do |spec|
	e = NetworkPool.new
	e.active = true
	e.ip = spec[:ip]
	e.port = spec[:port]
	puts "Error #{e.error.full_messages.to_s}" unless e.save
end
